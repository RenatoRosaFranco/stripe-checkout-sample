# frozen_string_literal: true

Rails.application.routes.draw do

  # Authentication
  devise_for :users

  # Application
  root 'pages#home'
  resources :payment_histories
  resources :charges
end
