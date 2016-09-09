require 'vcr'

def uri_escaped_attribute(value)
  return nil if value.nil?
  URI.escape(value).gsub('/', '%2F')
end

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = false
  config.hook_into :webmock
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.preserve_exact_body_bytes { false }
  config.default_cassette_options = {
      record: ENV['VCR_RECORD'] ? :all : :once,
      re_record_interval: 20.years,
      match_requests_on: [:method, :uri, :soap_request],
  }

  config.debug_logger = File.open('log/vcr.log', 'w') if ENV['VCR_DEBUG']
end
