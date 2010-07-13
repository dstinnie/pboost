class AddListableIdAndListableTypeToFilters < ActiveRecord::Migration
  def self.up
  	add_column :filters, :contact_list_id, :integer, :null => false
		add_index :filters, [:type, :contact_list_id]
  end

  def self.down
		remove_index :filters, [:type, :contact_list_id]
  	remove_column :filters, :contact_list_id
  end
end
