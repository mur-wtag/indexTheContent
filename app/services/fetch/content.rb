module Fetch
  class Contents
    attr_reader :crawl_url, :tags

    def initialize(url, tags)
      @crawl_url = url
      @tags = tags
    end

    def result
      # TODO: Crawl Here
    end
  end
end
