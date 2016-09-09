require 'spec_helper'

RSpec.describe HtmlSource::Api do
  let(:crawl_query_result) { FactoryGirl.create :crawl_query_result }
  let(:crawl_query) { crawl_query_result.crawl_query }
  let(:api) { described_class.new crawl_query }
  describe '#new' do
    it 'should set @crawl_query' do
      expect(api.instance_variable_get(:@crawl_query)).to eq crawl_query
    end
  end

  describe '#search' do

    before :each do
      allow(Scraper).
          to receive(:call).with(crawl_query.crawl_url, crawl_query.container_tags).and_return('crawl results')
    end

    it 'should call Scraper.call' do
      expect(Scraper).
          to receive(:call).with(crawl_query.crawl_url, crawl_query.container_tags).and_return('crawl results')
      api.scrapped_content
    end
  end
end
