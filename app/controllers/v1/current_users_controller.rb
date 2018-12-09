module V1
  class CurrentUsersController < ApplicationController
    def show
      render json: { email: current_user.email }
    end
  end
end