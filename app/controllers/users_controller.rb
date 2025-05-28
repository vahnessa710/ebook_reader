class UsersController < ApplicationController
  before_action :authenticate_user!
  
    def index; end

    def show; end

    def new
      @user = User.new
    end

    def create; end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

end
