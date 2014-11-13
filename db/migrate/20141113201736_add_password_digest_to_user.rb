class AddPasswordDigestToUser < ActiveRecord::Migration
  def change
	  remove_column :users, :password_hash
	  remove_column :users, :password_salt
	  add_column :users, :password_digest, :string
  end
end
