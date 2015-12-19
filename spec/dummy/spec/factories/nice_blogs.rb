FactoryGirl.define do
  factory :nice_blog, :class => 'Nice::Blog' do
    sequence(:title) { |i| "Nice Blog #{i}"}
    sequence(:url) { |i| "http://nice-blog-#{i}.webhooker.test" }
    created_at 3.days.ago
    updated_at 2.days.ago
  end
end
