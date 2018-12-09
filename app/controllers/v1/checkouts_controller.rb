class V1::CheckoutsController < ApplicationController
  def create
    customer = Stripe::Customer.create({
      email: current_user.email,
      source: token,
    })

    subscription = Stripe::Subscription.create({
      customer: customer.id,
      items: [{ plan: Rails.application.credentials.stripe[:plan_id] }],
    })

    current_user.update(
      payment_gateway_customer_id: customer.id,
      payment_gateway_subscription_id: subscription.id,
    )

    head :created
  end

  private
  def token
    params.require(:stripe_token)
  end
end
