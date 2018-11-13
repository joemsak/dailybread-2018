class V1::BillsController < ApplicationController
  def index
    if params[:pay_period]
      bills = V1::Bill.in_pay_period(params[:pay_period])
    else
      bills = V1::Bill.all
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
  end

  def destroy
    V1::Bill.find(params[:id]).destroy
  end

  private
  def bill_params
    params.require(:bill).permit(:name, :amount, :pay_period)
  end
end
