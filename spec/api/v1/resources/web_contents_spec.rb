require 'spec_helper'
require 'json'
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

  describe 'GET /web_contents/crawls/:id/results' do
    let!(:crawl_query_result) { FactoryGirl.create(:crawl_query_result) }
    let(:query_id) { crawl_query_result.crawl_query.id }
    let(:request_url) { "/api/web_contents/crawls/#{crawl_query_result.crawl_query.id}/results" }

    let(:expected_response) do
      [
        {
          query_id: query_id,
          container_tag: crawl_query_result.container_tag,
          content: crawl_query_result.content
        }
      ]
    end

    let(:parsed_response) { JSON.parse expected_response.to_json }

    context 'with valid crawl_query' do
      it 'returns crawled result' do
        get request_url, {}, basic_authentication.merge('Accept-Version' => 'v1')
        expect(JSON.parse(response.body)).to eq(parsed_response)
      end
    end

    context 'with invalid crawl_query' do
      let(:request_url) { '/api/web_contents/crawls/1331/results' }
      it 'returns crawled result' do
        get request_url, {}, basic_authentication.merge('Accept-Version' => 'v1')
        expect(response.status).to eq(404)
      end
    end
  end
end
