class CrawlQuery < ActiveRecord::Base
  has_many :crawl_query_results

  validates :crawl_url, format: URI::regexp(%w(http https)), presence: true
end
