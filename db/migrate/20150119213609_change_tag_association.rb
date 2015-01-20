class ChangeTagAssociation < ActiveRecord::Migration
  def change
		remove_column :transactions, :tag_id
  end
end
