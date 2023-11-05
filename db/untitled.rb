# frozen_string_literal: true

class ChargesController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    @amount = 5000
    customer = Stripe::Customer.create({
       email:  current_user.email,
       source: params[:stripeToken]
    })

    charge = Stripe::Charge.create({
      customer:    customer.id,
      amount:      @amount,
      description: 'Rails stripe customer',
      currency:    'usd'
    })
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end
end
