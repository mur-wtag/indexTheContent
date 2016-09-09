require 'spec_helper'

RSpec.describe CrawlQuery, type: :model do
  it { is_expected.to validate_presence_of(:crawl_url) }
end
