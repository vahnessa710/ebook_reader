class UsersController < ApplicationController
  before_action :authenticate_user!
  
    def index
    
    end

    def show

    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
        if @user.save
          UserMailer.registration_success(@user).deliver_now
          redirect_to admin_index_path, notice: "User created successfully."
        else
          render :new, status: :unprocessable_entity
        end
    end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

end
