class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :category
      t.string :detail
      t.integer :amount

      t.timestamps
    end
  end
end
