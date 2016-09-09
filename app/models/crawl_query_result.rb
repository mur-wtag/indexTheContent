class CrawlQueryResult < ActiveRecord::Base
  belongs_to :crawl_query

  validates :container_tag,
            presence: true,
            inclusion: { in: %w(h1 h2 h3 a),  message: '%{value} tag is not supported right now' }
end
