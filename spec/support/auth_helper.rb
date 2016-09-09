module AuthHelper
  def basic_authentication
    http_auth = ActionController::HttpAuthentication::Basic.encode_credentials('user1', 'password1')
    { 'HTTP_AUTHORIZATION' => http_auth }
  end
end
