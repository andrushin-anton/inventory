class CreateOrderItems < ActiveRecord::Migration[5.2]
  def change
    create_table :order_items do |t|
      t.integer :order_id
      t.string :item_name
      t.integer :quantity
      t.datetime :delivery_time
      t.float :price
      t.integer :item_id

      t.timestamps
    end
  end
end
