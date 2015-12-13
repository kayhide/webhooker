FactoryGirl.define do
  factory :webhooker_subscriber, class: 'Webhooker::Subscriber' do
    sequence(:url) { |i| "http://webhooker.test/subscriber/#{i}" }
    sequence(:secret) { |i| SecureRandom.hex(4) }
  end
end
