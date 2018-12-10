class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :pid
      t.string :customer
      t.string :status
      t.datetime :delivery_time

      t.timestamps
    end
  end
end
