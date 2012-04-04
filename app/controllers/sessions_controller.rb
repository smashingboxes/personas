class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to return_url
    else
      flash.now.alert = "Email or password is invalid"
      render "new"
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
