class ChangeBalanceType < ActiveRecord::Migration
  def change
	  change_column :users, :balance, :integer
  end
end