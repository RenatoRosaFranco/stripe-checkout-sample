# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @products = Product.all.page(params[:page])
                           .per(12)
  end
end