FactoryGirl.define do
  factory :crawl_query do
    crawl_url 'https://www.google.com'
    container_tags %w(h1 h2 h3)
  end
end
