module V1
  module Entities
    class IndexedContent < Shared::Entities::Base
      expose :crawl_query_id, as: :query_id
      expose :container_tag
      expose :content
    end
  end
end
