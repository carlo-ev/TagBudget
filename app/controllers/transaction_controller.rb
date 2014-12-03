class TransactionController < ApplicationController
	before_filter :authorize
	skip_before_filter :authorize, only: ['frontpage']
	
  def frontpage
	  if current_user then
		  redirect_to action: 'index'
	  end
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
  	  redirect_to action: 'index'
  end

  def history
	if params[:end] && params[:begin] then
		wantedRange = (Date.parse(params[:begin]) rescue Date.today).beginning_of_day..(Date.parse(params[:end]) rescue Date.today).end_of_day
		@transactions = @current_user.transactions.where(created_at: wantedRange).order('created_at DESC')
	elsif params[:begin] then
		wantedDay = (Date.parse params[:begin]) rescue Date.today
		@transactions = @current_user.transactions.where(created_at: wantedDay.beginning_of_day..wantedDay.end_of_day ).order('created_at DESC')
	else
		@transactions = @current_user.transactions.order('created_at DESC')
	end
  end

  def week
	  @days = Hash[(Date.today.at_beginning_of_week...Date.today.at_beginning_of_week+7).collect { |day| [day.dayname, Array.new] }]
	  weekTransactions = Transaction.where( created_at: Date.today.at_beginning_of_week.beginning_of_day..(Date.today.at_beginning_of_week+7).end_of_day ).order('created_at DESC')
	  weekTransactions.each do |transaction|
		  @days[transaction.created_at.to_date.dayname].push(transaction)
	  end
  end

  def destroy
	  if Transaction.find(params[:id]).try(:delete) then
		  redirect_to action: :index
	  else
		  redirect_to action: :show
	  end
  end
	
  private
	def transaction_params
		params.require(:transaction).permit(:category, :detail, :amount)
	end
end
