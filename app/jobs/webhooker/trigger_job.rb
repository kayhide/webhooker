module Webhooker
  class TriggerJob < ActiveJob::Base
    queue_as :default

    def perform subscriber, data
      @subscriber = subscriber
      @data = data
      uri = URI.parse subscriber.url
      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data payload
      Net::HTTP.new(uri.host, uri.port).start do |http|
        app = Rails.application.class.parent.to_s
        body = payload.to_json
        header = {
          'Content-Type' => 'application/json',
          'User-Agent' => app,
          "X-#{app}-Signature" => create_signature(body)
        }
        http.post uri.path, body, header
      end
    end

    def create_signature body
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), @subscriber.secret, body)
    end

    def payload
      @payload ||=
        if Webhooker.config.payload_key.present?
          { Webhooker.config.payload_key => @data }
        else
          @data
        end
    end
  end
end
