require 'spec_helper'

RSpec.describe V1::Entities::IndexedContent do
  let(:crawl_query_result) { FactoryGirl.create :crawl_query_result }
  let(:crawl_query) { crawl_query_result.crawl_query }
  let(:crawl_entity) { V1::Entities::IndexedContent.represent(crawl_query_result) }

  subject { JSON.parse(crawl_entity.to_json) }

  it 'matches the api specification' do
    expect(subject).
      to eq(
         'query_id' => crawl_query.id,
         'container_tag' => crawl_query_result.container_tag,
         'content' => crawl_query_result.content
      )
  end
end
