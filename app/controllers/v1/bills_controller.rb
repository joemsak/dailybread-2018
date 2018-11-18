class V1::BillsController < ApplicationController
  def index
    if period = params.transform_keys(&:underscore)[:pay_period]
      income = current_user.income
      bills = current_user.bills.in_pay_period(period, income).order(:created_at)
    else
      bills = current_user.bills.all.order(:created_at)
    end

    render json: V1::BillSerializer.new(bills).serialized_json
  end

  def show
    bill = current_user.bills.find(params[:id])
    render json: V1::BillSerializer.new(bill).serialized_json
  end

  def create
    bill = current_user.bills.create!(bill_params)
    render json: V1::BillSerializer.new(bill).serialized_json, status: 201
  end

  def update
    bill = current_user.bills.find(params[:id])
    bill.update(bill_params)
    head :no_content
  end

  def destroy
    current_user.bills.find(params[:id]).destroy
    head :no_content
  end

  private
  def bill_params
    params.transform_keys(&:underscore)
      .require(:bill)
      .transform_keys(&:underscore)
      .permit(:name, :amount, :pay_period)
  end
end
