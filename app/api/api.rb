module API
  class Dispatch < Grape::API
    PAGINATION_MAX_PER_PAGE = 300
    PAGINATION_DEFAULT_PER_PAGE = 50

    include Grape::Kaminari
    include ApiExceptionHandling

    version 'v1', using: :accept_version_header, vendor: 'mur', strict: true
    format :json

    #
    # Authentication
    #
    #
    # before do
    #   # Should use OAuth 2.0
    #   #doorkeeper_authorize!
    # end

    http_basic do |username, password|
      { 'user1' => 'password1' }[username] == password
    end

    helpers do
      #
      # Strong Parameters
      #

      def permitted_params
        declared(params, include_missing: false)
      end

      def resource_params
        permitted_params.except(:page, :per_page, :offset)
      end
    end

    #
    # Pagination
    #
    before do
      # grape-kaminari will always return a page header of the given per_page param
      # and not the really used (and maybe enforced) value
      if params[:per_page] && params[:per_page].to_i > PAGINATION_MAX_PER_PAGE
        params[:per_page] = PAGINATION_MAX_PER_PAGE
      end

      # grape-kaminari will not return a header with the default value if there was no
      # per_page param
      params[:per_page] ||= PAGINATION_DEFAULT_PER_PAGE
    end

    #
    # Ping? Pong!
    #
    desc 'Ping? Pong!'
    get :ping do
      { pong: Time.now }
    end

    #
    # Resources
    #
    mount V1::Resources::WebContents
  end

  Base = Rack::Builder.new do
    run API::Dispatch
  end
end
