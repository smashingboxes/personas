class PasswordResetsController < ApplicationController
  def new
    scrape_client_page(new_password_reset_path)
  end

  def create
    user = User.where(email: params[:email]).first
    if user
      options = { query: { email: user.email } }
      url = session['ref'].to_s + "/password_resets"
      response = HTTParty.post(url, options)
      if response.body == "success"
        scrape_client_page new_password_reset_path,
        notice: "Email sent with password reset instructions."
      else
        scrape_client_page new_password_reset_path,
        notice: "Sorry, you haven't created an account for this site yet."
      end
    else
      scrape_client_page new_password_reset_path,
      error: "Sorry, no user was found with email address \"#{params[:email]}\"."
    end
  end

  def edit
    scrape_client_page(edit_password_reset_path)
    # if current_user
    #   @user = current_user
    # else
    #   redirect_to root_url
    # end
  end

  def update
    if current_user
      if current_user.update_attributes(params[:user])
        redirect_to root_url, :notice => "Password has been reset!"
      else
        @user = current_user
        render :edit
      end
    else
      redirect_to new_password_reset_url, :notice => "Please submit your email and follow the link to reset your password."
    end
  end
end
