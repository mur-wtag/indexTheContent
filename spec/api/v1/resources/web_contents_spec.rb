require 'spec_helper'

RSpec.describe V1::Resources::WebContents do
  describe 'POST /web_contents/crawls' do
    let(:content_crawl_double) { instance_double(::WebContents::Crawl) }
    let(:container_tags) { %w(h1 h2 h3) }
    let(:valid_params) do
    {
      crawl_url: 'https://www.github.com',
      container_tags: container_tags,
    }
    end


    let(:combined_result) { OpenStruct.new(valid_response.merge(id: 1)) }

    let(:request_url) { '/api/web_contents/crawls' }

    context 'incomplete parameters' do
      it 'requires crawl_url' do
        post request_url, valid_params.except(:crawl_url), basic_authentication.merge('Accept-Version' => 'v1')
        expect(response.status).to eq(422)
      end
    end

    context 'invalid parameters' do
      before do
        post request_url, valid_params, basic_authentication.merge('Accept-Version' => 'v1')
      end

      subject { response.status }

      context 'code is not permitted tag' do
        let(:container_tags) { 'code' }
        it { is_expected.to eq(422) }
      end
    end

    context 'complete parameters' do
      before do
        allow(::WebContents::Crawl).to receive(:new).with(valid_params).and_return(content_crawl_double)
        allow(content_crawl_double).to receive(:results).and_return([])
        allow(content_crawl_double).to receive(:id).and_return(1331)
      end

      it 'calls the Crawl class' do
        expect(::WebContents::Crawl).to receive(:new).and_return(content_crawl_double)
        expect(content_crawl_double).to receive(:results).and_return([])
        expect(content_crawl_double).to receive(:id).and_return(1331)

        post request_url, valid_params, basic_authentication.merge('Accept-Version' => 'v1')
      end

      it 'provides valid parameters to the crawl class' do
        crawl_params = {
            crawl_url: 'https://www.github.com',
            container_tags: container_tags,
        }

        expect(::WebContents::Crawl).to receive(:new).with(crawl_params).and_return(content_crawl_double)
        post request_url, valid_params, basic_authentication.merge('Accept-Version' => 'v1')
      end

      it 'returns the id of the crawl result' do
        post request_url, valid_params, basic_authentication.merge('Accept-Version' => 'v1')
        expect(JSON.parse(response.body)).to eq('id' => 1331)
      end
    end
  end
end
