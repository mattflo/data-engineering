class AddMerchantIdToItem < ActiveRecord::Migration
  def change
    add_column :items, :merchant_id, :integer
  end
end
