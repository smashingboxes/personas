class SessionsController < ApplicationController
  def new
    scrape_client_page("/login")
  end

  def create
    user = User.find_by_email(params[:email].downcase)
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session['ref'] = nil
      redirect_to return_url
    else
      scrape_client_page("/login", error: "Email or password is invalid.")
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
end
