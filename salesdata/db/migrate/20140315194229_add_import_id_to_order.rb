class AddImportIdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :import_id, :integer
  end
end
