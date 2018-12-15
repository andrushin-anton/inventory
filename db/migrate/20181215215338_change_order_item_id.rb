class ChangeOrderItemId < ActiveRecord::Migration[5.2]
  def change
    change_column :order_items, :order_id, :string
  end
end
