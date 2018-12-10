module V1
  class CurrentUsersController < ApplicationController
    def show
      subscription = if subscription_id = current_user.payment_gateway_subscription_id
        Stripe::Subscription.retrieve(subscription_id)
      else
        Struct.new(:status).new("unpaid")
      end

      render json: { email: current_user.email, subscription: subscription }
    end
  end
end