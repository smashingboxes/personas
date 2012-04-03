class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def regrant_existing_authorization
    oauth2_authorization_request.grant_existing! current_user
  end

  def set_return_url
    session[:return_url] = request.request_uri
  end

  def return_url(params = {})
    if session[:return_url]
      if params.empty?
        session[:return_url]
      else
        session[:return_url] + "?" + params.to_param
      end
    else
      flash[:notice] = params[:message]
      root_url
    end
  end

  def authenticate_user
    unless current_user
      session[:return_url] = request.fullpath
      session[:client_id] = params[:client_id]

      respond_to do |format|
        format.html { redirect_to new_session_path }
        format.json { render json: { error: "access denied" } }
      end
    end
  end

  def set_current_user_from_oauth
    @current_user = request.env['oauth2'].resource_owner
  end

  def client
    @client ||= OAuth2::Provider::Models::Mongoid::Client.where({oauth_identifier: session[:client_id]}).first
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :client, :current_user

  def authorize
    redirect_to login_url, alert: "Not authorized" if current_user.nil?
  end
end
