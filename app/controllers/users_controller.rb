class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    render :show
  end

  def new
    render :new
  end

  def create
    user = User.new(user_params)
    if user.save
      log_in_user!(user) #why would this be in the application controller instead of the User model?
      redirect_to user_url(user)
    else
      flash.now[:errors] = user.errors.full_messages #makes a key value pair exist in the flash hash for just this same cycle.
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :session_token)
  end
end
