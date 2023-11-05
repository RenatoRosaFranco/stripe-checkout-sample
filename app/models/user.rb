# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  stripe_customer_id     :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  self.table_name  = 'users'
  self.primary_key = 'id'

  # Callbacks
  after_create :create_stripe_customer_id

  # Relationships
  has_many :payment_histories

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validations
  validates :name, presence: true
  validates :stripe_customer_id, uniqueness: true

  # Create the stripe customer id
  def create_stripe_customer_id
    return if stripe_customer_id.present?

    customer = Stripe::Customer.create({ email: email, name: name })
    update(stripe_customer_id: customer.id)
  end
end
