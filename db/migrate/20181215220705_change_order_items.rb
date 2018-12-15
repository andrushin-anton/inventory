class ChangeOrderItems < ActiveRecord::Migration[5.2]
  def change
    change_column :order_items, :item_id, :string
    change_column :order_items, :order_id, :integer
  end
end
