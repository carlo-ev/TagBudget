class Transaction < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :tags

	def self.build_transaction(description)
		description_parts = description.split
		tags, amounts, balance = [], [], []
		
		description_parts.each do |word|
			if word.start_with?'#' then
				word[0] = ''
				tags.push word.capitalize
				description.slice! word
			end
			if (Integer(word) rescue false) then
				amounts.push Integer(word)
				description.slice! word
			end
=begin
			if word.start_with? '%' then
				word[0] = ''
				balance.push word.capitalize
				description.slice! word
			end
=end
		end
				
		new_transaction = Transaction.new
		new_transaction.amount = amounts[0]
		new_transaction.detail = description
		db_tags = Tag.all
		db_tags.each do |tg|
				if	tags.include? tg.name then
					new_transaction.tags << tg
					tags.delete(tg.name)
				end
		end
		tags.each do |name|
				new_tag = Tag.new
				new_tag.name = name
				if new_tag.save then
					new_transaction.tags << new_tag
				end
		end
		new_transaction
	end
			
end
