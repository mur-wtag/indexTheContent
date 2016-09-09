require 'spec_helper'

RSpec.describe CrawlQueryResult, type: :model do
  it { is_expected.to validate_presence_of(:container_tag) }
  it { is_expected.to validate_inclusion_of(:container_tag).in_array(%w(h1 h2 h3 a)) }
end
