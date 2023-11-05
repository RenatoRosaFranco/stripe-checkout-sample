class CreatePaymentHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_histories do |t|
      t.references :user, foreign_key: true
      t.references :product, foreign_key: true
      t.float :price

      t.timestamps
    end
  end
end
