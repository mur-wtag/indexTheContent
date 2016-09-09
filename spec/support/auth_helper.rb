module AuthHelper
  def request_with_basic_auth(method, url, params = {}, env = {})
    @auth_request_user ||= FactoryGirl.create(:api_user, password: 'password')
    http_auth =
        ActionController::HttpAuthentication::Basic.encode_credentials(@auth_request_user.username, 'password')
    send(method, url, params, env.merge('HTTP_AUTHORIZATION' => http_auth))
  end

  def generate_access_token_for(user = nil)
    user ||= FactoryGirl.create(:user)
    application_attributes = {
        name: Faker::App.name,
        redirect_uri: 'https://app.com',
        owner: user.tenant,
    }
    application = Doorkeeper::Application.create!(application_attributes)
    access_token = Doorkeeper::AccessToken.create!(application_id: application.id,
                                                   resource_owner_id: user.id)
    access_token.token
  end
end
