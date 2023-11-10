class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    if current_user == User.find(params[:id])
      respond_to do |format|
        if user_params[:username].nil? && @user == current_user && @user.update(user_params)
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, notice: "You cannot edit another user's details!"
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    if current_user == User.find(params[:id])
      current_user.destroy
      session[:user_id] = nil # log out
      redirect_to root_path, notice: 'Your account has been deleted.'
    else
      redirect_to root_path, notice: 'You cannot delete another user\'s account!'
    end
  end

  def close_account
    @user = User.find(params[:id])
    if current_user.admin?
      @user.update_column(:account_closed, true)
      redirect_to users_path, notice: "Account has been closed."
    else
      redirect_to users_path, alert: "You are not authorized to perform this action."
    end
  end

  def open_account
    @user = User.find(params[:id])
    if current_user.admin?
      @user.update_column(:account_closed, false)
      redirect_to users_path, notice: "Account has been opened."
    else
      redirect_to users_path, alert: "You are not authorized to perform this action."
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
