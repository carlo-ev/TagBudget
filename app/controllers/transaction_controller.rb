class TransactionController < ApplicationController
	before_filter :authorize
	skip_before_filter :authorize, only: ['frontpage']
	
  def frontpage
  end
	
  def index
	  @transaction = @current_user.transactions.new
	  #@transactions = @current_user.transactions.limit(15).order('created_ad DESC')
	  @transactions = Transaction.all().order('created_at DESC')
  end

  def show
	  @transaction = Transaction.find(params[:id])
  end

  def create
	  fullCategory = transaction_params[:category].split
	  @transaction = @current_user.transactions.new #Transaction.new
	  @transaction.category = fullCategory[0]
	  @transaction.amount = fullCategory[1].to_i
	  @transaction.detail = fullCategory[2..-1].join(' ')
	  @transaction.save
	  @current_user.balance += @transaction.amount
	  @current_user.save
	  #Transaction.create(transaction_params)
  	  redirect_to(action: 'index')
  end

  def history
	  @transactions = @current_user.transactions.order('created_at DESC') #Transaction.all()
  end

  def week
	  @days = Hash[(Date.today.at_beginning_of_week...Date.today.at_beginning_of_week+7).collect { |day| [day.dayname, Array.new] }]
	  weekTransactions = Transaction.where( created_at: Date.today.at_beginning_of_week.beginning_of_day..(Date.today.at_beginning_of_week+7).end_of_day ).order('created_at DESC')
	  weekTransactions.each do |transaction|
		  @days[transaction.created_at.to_date.dayname].push(transaction)
	  end
  end

  def edit
  end

  def update
  end

  def delete
  end
	
  private
	def transaction_params
		params.require(:transaction).permit(:category, :detail, :amount)
	end
end
