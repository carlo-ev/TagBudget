module History
	extend ActiveSupport::Concern
	
	def get_history(start, finish)
		if start || finish then 
			start = start ? (Date.parse(start) rescue Date.today) : Date.today
			finish = finish ? (Date.parse(finish) rescue Date.today) : Date.today
			transactions = self.transactions.where(created_at: start.beginning_of_day..finish.end_of_day).order('created_at DESC')
		else
			transactions = self.transactions.order('created_at DESC')
		end
		transactions
	end
		
	def get_week
		week = (Date.today.at_beginning_of_week...Date.today.at_beginning_of_week+7).collect { |day| day.dayname }
		#Hash[(Date.today.at_beginning_of_week...Date.today.at_beginning_of_week+7).collect { |day| [day.dayname, Array.new] }]
		trans = self.transactions.where( created_at: Date.today.at_beginning_of_week.beginning_of_day..(Date.today.at_beginning_of_week+7).end_of_day ).order('created_at DESC')
		trans_array = []
		trans.each do |transaction|
			index  = week.index(transaction.created_at.to_date.dayname)
			unless trans_array[index] then
				trans_array[index] = []
			end
			#week[transaction.created_at.to_date.dayname].push(transaction)
				trans_array[index].push transaction
		end
			puts trans_array.size
		[week, trans_array]
	end
	
end