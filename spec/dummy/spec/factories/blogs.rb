FactoryGirl.define do
  factory :blog do
    sequence(:title) { |i| "Blog #{i}"}
    sequence(:url) { |i| "http://blog-#{i}.webhooker.test" }
    created_at 3.days.ago
    updated_at 2.days.ago
  end
end
