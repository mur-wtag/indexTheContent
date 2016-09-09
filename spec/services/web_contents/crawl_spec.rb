require 'spec_helper'

RSpec.describe WebContents::Crawl do
  let(:crawl_url) { 'https://www.google.com/about/company/' }
  let(:tags) { %w(h1 h2 h3) }
  let(:crawl_parameters) do
    {
        crawl_url: crawl_url,
        container_tags: tags,
    }
  end
  let(:instance) { described_class.new(crawl_parameters) }
  let(:crawl) do
    VCR.use_cassette('web_contents/crawl') do
      instance.results
    end
  end

  describe '#id' do
    context '#id' do
      it 'returns the id of the crawl query' do
        expect(instance.id).to eq(instance.crawl_query.id)
      end
    end
  end

  context '#results' do
    let(:fetch_instance) { HtmlSource::Api.new(crawl_query) }
    let(:source_api_double) { instance_double(HtmlSource::Api) }

    context 'no results' do
      before do
        allow(HtmlSource::Api).to receive(:new).and_return(source_api_double)
        allow(source_api_double).to receive(:scrapped_content).and_return([])
      end

      it 'tests has a blank result' do
        expect(instance.results).to eq([])
      end

      it 'tests crawl_query count' do
        expect { instance }.to change { CrawlQuery.count }.from(0).to(1)
      end

      it 'tests CrawlQuery count' do
        expect { instance.results }.to_not change(CrawlQueryResult, :count)
      end
    end

    context 'a result found' do
      it 'tests has a blank result' do
        expect(crawl).not_to be_nil
      end

      it 'tests CrawlQuery count' do
        expect { crawl }.to change { CrawlQueryResult.count }.from(0).to(15)
      end
    end
  end
end
