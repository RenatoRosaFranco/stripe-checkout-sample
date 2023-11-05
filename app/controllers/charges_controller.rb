# frozen_string_literal: true

class ChargesController < ApplicationController
  before_action :set_product
  before_action :authenticate_user!

  def new
    if @product.quantity.eql?(0)
      flash[:notice] = 'Product out of stock.'
      return redirect_to root_path
    end

    @product = Product.find(params[:product_id])
  end

  def create
    product        = Product.find(params[:product_id])
    return_url     = 'https://localhost:3000'

    source         = Stripe::Source.create({ type: 'card', token: params[:stripeToken] })
    payment_intent = Stripe::PaymentIntent.create({
      amount:               (product.price * 100).to_i,
      currency:             'BRL',
      source:               source.id,
      customer:             current_user.stripe_customer_id,
      description:          "Product ID: #{product.id}, for customer #{current_user.email}",
      statement_descriptor: 'Custom descriptor',
      receipt_email:        current_user.email,
      confirm:              true,
      metadata:             { order_id: '12345' },
      return_url:           return_url
    })

    if payment_intent.status.eql?('requires_confirmation')
      create_payment(product)
      update_product_stock(product)
      payment_intent.confirm({ return_url: return_url })
    elsif payment_intent.status.eql?('succeeded')
      create_payment(product)
      update_product_stock(product)
      flash[:success] = 'Payment successful'
      redirect_to root_path
    else
      flash[:error] = 'Payment failed or requires authentication. Please try again.'
      redirect_to new_charge_path(product_id: product.id)
    end
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path(product_id: product.id)
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def create_payment(product)
    current_user.payment_histories.create!(product: product)
  end

  def update_product_stock(product)
    product.quantity = product.quantity - 1
    product.save
  end
end
