module WebContents
  class Crawl
    attr_reader :crawl_query

    RESULT_FIELDS = %i(container_tag content crawl_query_id).freeze

    IMPORT_OPTIONS = { recursive: false, validate: false }.freeze

    def initialize(crawl_parameters)
      @crawl_query = CrawlQuery.create! crawl_parameters
    end

    def id
      crawl_query.id
    end

    def results
      crawl
      import_results
      crawl_query.crawl_query_results
    end

    def crawl
      return @crawl if @crawl
      contents = Fetch::Contents.new(crawl_query.crawl_url, crawl_query.container_tags)
      results = contents.result

      @crawl = results.map do |tag, contents|
        [contents].flatten.map do |content|
          build_query_result(tag, content)
        end
      end

      @crawl
    end

    def import_results
      results = crawl.map { |result| result[:values] }
      CrawlQueryResult.import(RESULT_FIELDS.dup, results, IMPORT_OPTIONS).ids
    end

    def build_query_result(tag, content)
      result_values = []
      RESULT_FIELDS.each do |column|
        value = case column
                when :crawl_query_id
                  crawl_query.id
                when :container_tag
                  tag
                when :content
                  content
                end
        result_values << value
      end

      { values: result_values }
    end
  end
end
