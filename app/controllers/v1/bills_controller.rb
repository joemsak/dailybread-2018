class V1::BillsController < ApplicationController
  def index
    if period = params.transform_keys(&:underscore)[:pay_period]
      bills = V1::Bill.in_pay_period(period).order(:created_at)
    else
      bills = V1::Bill.all.order(:created_at)
    end

    render json: V1::BillSerializer.new(bills).serialized_json
  end

  def show
    bill = V1::Bill.find(params[:id])
    render json: V1::BillSerializer.new(bill).serialized_json
  end

  def create
    bill = V1::Bill.create!(bill_params)
    render json: V1::BillSerializer.new(bill).serialized_json, status: 201
  end

  def update
    bill = V1::Bill.find(params[:id])
    bill.update(bill_params)
    head :no_content
  end

  def destroy
    V1::Bill.find(params[:id]).destroy
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
