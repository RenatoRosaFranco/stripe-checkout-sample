# == Schema Information
#
# Table name: products
#
#  id         :integer          not null, primary key
#  name       :string
#  price      :float
#  quantity   :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Product < ApplicationRecord
  self.table_name  = 'products'
  self.primary_key = 'id'

  has_many :payment_histories
end
