require 'spec_helper'

RSpec.describe Scraper do
  let(:crawl_url) { 'https://www.github.com' }
  let(:tags) { %w(h1 h2 h3) }
  let(:instance) { described_class.new(crawl_url, tags) }

  let(:expected_content) do
    {
      'h1' => ['How people build software'],
      'h2' => ['Welcome home, developers', 'Who uses GitHub?'],
      'h3' => ['Join us at GitHub Universe', 'Individuals', 'Communities', 'Businesses']
    }
  end
  
  subject do
    VCR.use_cassette('scraper') do
      instance.call
    end
  end

  context '#call' do
    it { is_expected.to eq expected_content }
  end
end
