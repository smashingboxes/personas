class AuthorizationController < ApplicationController
  include OAuth2::Provider::Rack::AuthorizationCodesSupport

  before_filter :authenticate_user
  before_filter :block_invalid_authorization_code_requests
  before_filter :regrant_existing_authorization
  
  def new
    @client = oauth2_authorization_request.client
  end

  def create
    grant_authorization_code(current_user)
  end

end
