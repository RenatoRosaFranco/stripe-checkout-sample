# frozen_string_literal: true

class PaymentHistoriesController < ApplicationController
  def index
    @payments = current_user.payment_histories.page(params[:page])
                                              .per(9)
  end
end