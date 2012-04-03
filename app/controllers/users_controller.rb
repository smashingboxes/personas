class UsersController < ApplicationController
  # authenticate_with_oauth
  before_filter :set_current_user_from_oauth, :except => [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, notice: "Thank you for signing up!"
    else
      render "new"
    end
  end

  # GET /profile.json
  def profile
    if @current_user
      render json: @current_user
    else
      render json: {'error' => 'no user'}
    end
  end

  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      render json: {"success" => "true"}
    else
      render json: @user.errors["password"].first, status: :unprocessable_entity
    end
  end

  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    head :ok
  end

  # GET /users/find_by_role/:role
  def find_by_role
    if role = Role.where(name: params[:role]).first
      render json: role.accounts
    else
      render :json => {error:"not found"}
    end
  end
end
