require 'spec_helper'

RSpec.describe API do

  it 'responds to /ping if authenticated' do
    get '/api/ping', nil, basic_authentication.merge('Accept-Version' => 'v1')
    expect(response.status).to eq(200)
  end

  it 'responds to /ping if not authenticated' do
    get '/api/ping', nil, 'Accept-Version' => 'v1'
    expect(response.status).to eq(401)
  end
end
