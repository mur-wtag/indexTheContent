class CrawlQueryResult < ActiveRecord::Base
  belongs_to :crawl_query

  validates :container_tag, presence: true
end
