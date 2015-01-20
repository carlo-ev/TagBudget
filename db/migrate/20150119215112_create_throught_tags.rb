class CreateThroughtTags < ActiveRecord::Migration
  def change
    create_table :tags_transactions do |t|
			t.belongs_to :transaction, index: true
			t.belongs_to :tag, index: true 
    end
  end
end
