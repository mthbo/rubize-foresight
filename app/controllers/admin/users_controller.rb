class Admin::UsersController < ApplicationController

  before_action :find_user, only: [:update]

  def index
    @users_approved = User.where(approved: true)
    @users_not_approved = User.where(approved: false)
  end

  def update
    @user.update(user_params)
    flash[:notice] = "#{@user.email} has been updated"
    redirect_to admin_users_path
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    puts params
    params.require(:user).permit(:approved, :admin)
  end

end
