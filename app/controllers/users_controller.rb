class UsersController < ApplicationController
  authenticate_with_oauth :except => [:new, :create]
  before_filter :set_current_user_from_oauth, :except => [:new, :create]

  def new
    scrape_client_page("/signup")
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.json { render json: { uid: @user.id } }
        format.html { redirect_to session[:ref].to_s + "/auth/alphalogin", notice: "Thank you for signing up!" }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.html { scrape_client_page("/signup", error: @user.errors.full_messages.to_sentence) }
      end
    end
  end

  # GET /profile.json
  def profile
    if @current_user
      @user = @current_user
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
