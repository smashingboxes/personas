class ApplicationController < ActionController::Base
  include UrlHelper

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

  def scrape_client_page(page, message = nil)
    # Check if user is coming from another site
    ref = make_absolute(URI.encode(request.env['HTTP_REFERER']))
    host = make_absolute(request.url)
    if host != ref || session[:ref].present?
      # User is coming from client app
      if ref != host
        session[:ref] = ref
      else
        ref = session[:ref]
      end
      # Get the client app's page and alter it,
      # adding authenticity token and rewritting urls.
      if message
        url = "#{ref}#{page}?#{message.keys.first}=#{URI.escape(message.values.first)}"
      else
        url = "#{ref}#{page}"
      end
      doc = Nokogiri::HTML(open(url))
      if token = doc.at_css("input[name=authenticity_token]")
        token["value"] = form_authenticity_token
      end
      doc.css("a").map {|a|rewrite(a, 'href', ref)}
      doc.css("img").map {|img|rewrite(img, 'src', ref)}
      doc.css("link").map {|l|rewrite(l, 'href', ref)}
      doc.css("script").map {|s|rewrite(s, 'src', ref)}
      render :text => doc.to_s
    end
  end
end
