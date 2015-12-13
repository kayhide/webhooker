require 'rails_helper'

module Webhooker
  RSpec.describe TriggerJob, type: :job do
    let(:subscriber) { FactoryGirl.create(:webhooker_subscriber) }
    let(:payload) { { a: 1, b: 2 } }

    describe '#perform' do
      before do
        @requests = []
        WebMock.after_request do |req, _|
          @requests << req
        end
      end

      it 'posts to subscriber url' do
        stub_request(:post, subscriber.url)
        subject.perform subscriber, payload
        expect(@requests.length).to eq 1

        req = @requests.first
        uri = URI.parse subscriber.url
        expect(req.uri.host).to eq uri.host
        expect(req.uri.path).to eq uri.path
      end

      it 'adds signature' do
        stub_request(:post, subscriber.url)
        expect(subject).to receive(:create_signature) { 'signature' }
        subject.perform subscriber, payload

        req = @requests.first
        expect(req.headers['X-Dummy-Signature']).to eq 'signature'
      end

      it 'adds json body' do
        stub_request(:post, subscriber.url)
        subject.perform subscriber, payload

        req = @requests.first
        expect(JSON.parse(req.body)).to eq payload.stringify_keys
      end
    end

    describe '#create_signature' do
      it 'creates signature' do
        subscriber.secret = '1234'
        subject.instance_variable_set(:@subscriber, subscriber)

        expect(subject.create_signature('something'))
          .to eq OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), '1234', 'something')
      end
    end
  end
end
