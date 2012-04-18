class SessionsController < ApplicationController
  include UrlHelper

  def new
    render_login
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session['ref'] = nil
      redirect_to return_url
    else
      render_login("Email or password is invalid.")
    end
  end

  def destroy
    # Remove user's session and return url
    session[:user_id] = session[:return_url] = nil
    if params[:redirect] 
      redirect_to params[:redirect]  
    else
      redirect_to root_url, :notice => "Logged out!"
    end
  end

  private
  def render_login(error = nil)
    # Check if user is coming from another site
    ref = make_absolute(request.env['HTTP_REFERER'])
    host = make_absolute(request.url)
    if host != ref || session[:ref].present?
      # User is coming from client app
      if ref != host
        session[:ref] = ref
      else
        ref = session[:ref]
      end
      # Get the client app's login page and alter it,
      # adding authenticity token and rewritting urls.
      if error
        url = "#{ref}/login?error=#{URI.escape(error)}"
      else
        url = "#{ref}/login"
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
