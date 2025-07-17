class UsersController < ApplicationController
<<<<<<< HEAD
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

=======
    def update_theme
        if current_user.update(theme: params[:theme].to_i)
            render json: { theme: current_user.theme }, status: :ok
        else
            render json: { errors: current_user.errors }, status: :unprocessable_entity
        end
    end
>>>>>>> origin/book_branch_2
end
