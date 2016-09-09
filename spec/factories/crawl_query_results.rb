FactoryGirl.define do
  factory :crawl_query_result do
    container_tag 'h1'
    content 'i am a content'
    crawl_query
  end
end
