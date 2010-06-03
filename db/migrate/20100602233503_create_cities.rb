class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.string :name, :limit => 64, :null => false
			t.references :county, :null => false

      t.timestamps
    end
    add_index :cities, :name
    add_index :cities, [:name, :county_id], :unique => true
  end

  def self.down
    drop_table :cities
  end
end
