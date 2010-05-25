class CreateUsers < ActiveRecord::Migration

  def self.up
    create_table :users do |t|
    	t.string :username, :null => false, :limit => 100
      t.string :email, :null => false, :limit => 100
      t.string :first_name, :null => false, :limit => 32
      t.string :last_name, :null => false, :limit => 32
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token, :null => false
      t.string :perishable_token, :null => false
      
      #These fields are automatically maintained by AuthLogic
      t.integer :login_count, :null => false, :default => 0
      t.integer :failed_login_count, :null => false, :default => 0
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string :current_login_ip
      t.string :last_login_ip

      t.timestamps
    end
    
  end

  def self.down
    drop_table :users
  end
end

