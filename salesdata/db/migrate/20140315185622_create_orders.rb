class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :purchaser, index: true
      t.references :item, index: true
      t.integer :quantity

      t.timestamps
    end
  end
end
