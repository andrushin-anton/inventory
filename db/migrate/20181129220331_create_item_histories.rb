class CreateItemHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :item_histories do |t|
      t.string :author
      t.string :description
      t.integer :item_id
      t.integer :quantity

      t.timestamps
    end
  end
end
