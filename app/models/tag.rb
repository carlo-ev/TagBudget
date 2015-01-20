class Tag < ActiveRecord::Base
	validates :name, uniqueness: {case_sensitive: false}
	has_and_belongs_to_many :trans, foreign_key: 'tag_id', class_name: 'Transaction'
end
