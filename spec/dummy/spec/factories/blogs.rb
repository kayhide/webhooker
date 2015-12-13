FactoryGirl.define do
  factory :blog do
    sequence(:title) { |i| "Blog #{i}"}
    sequence(:url) { |i| "http://blog-#{i}.webhooker.test" }
  end
end
