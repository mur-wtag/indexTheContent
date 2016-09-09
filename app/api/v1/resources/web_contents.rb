module V1
  module Resources
    class WebContents < Grape::API
      namespace :web_contents do
        desc 'Crawl a website'
        params do
          requires :crawl_url,
                   type: String,
                   desc: 'URL of crawling website'
          optional :container_tags,
                   type: Array,
                   values: -> { %w(h1 h2 h3 a) },
                   default: %w(h1 h2 h3 a),
                   desc: 'Crawl only content of these tags'
        end
        post :crawls do
          crawl_parameters = {
              crawl_url: resource_params[:crawl_url],
              container_tags: resource_params[:container_tags],
          }
          crawl = ::WebContents::Crawl.new(crawl_parameters)
          crawl.results

          present id: crawl.id
        end

        desc 'Show Crawled content of a specific Query'
        get 'crawls/:id/results' do
          crawl_query = CrawlQuery.find_by_id! resource_params[:id]

          present crawl_query.crawl_query_results, with: V1::Entities::IndexedContent
        end
      end
    end
  end
end
