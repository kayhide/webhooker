module Webhooker
  class TriggerJob < ActiveJob::Base
    queue_as :default

    def perform subscriber, payload
      @subscriber = subscriber
      uri = URI.parse subscriber.url
      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data payload
      Net::HTTP.new(uri.host, uri.port).start do |http|
        app = Rails.application.class.parent.to_s
        body = payload.to_json
        header = {
          'Content-Type' => 'application/json; charset=utf-8',
          'User-Agent' => app,
          "X-#{app}-Signature" => create_signature(body)
        }
        http.post uri.path, body, header
      end
    end

    def create_signature body
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), @subscriber.secret, body)
    end
  end
end
