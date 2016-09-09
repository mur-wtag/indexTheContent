module HtmlSource
  class Api
    attr_reader :crawl_query

    def initialize(crawl_query)
      @crawl_query = crawl_query
    end

    def scrapped_content
      Scraper.call(crawl_query.crawl_url, crawl_query.container_tags)
    end
  end
end
