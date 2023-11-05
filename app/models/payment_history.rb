# == Schema Information
#
# Table name: payment_histories
#
#  id         :integer          not null, primary key
#  price      :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  product_id :integer
#  user_id    :integer
#
# Indexes
#
#  index_payment_histories_on_product_id  (product_id)
#  index_payment_histories_on_user_id     (user_id)
#
class PaymentHistory < ApplicationRecord
  belongs_to :user
  belongs_to :product
end
