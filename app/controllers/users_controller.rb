class UsersController < ApplicationController
    def update_theme
        if current_user.update(theme: params[:theme].to_i)
            render json: { theme: current_user.theme }, status: :ok
        else
            render json: { errors: current_user.errors }, status: :unprocessable_entity
        end
    end
end
