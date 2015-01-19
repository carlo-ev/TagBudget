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
	  @transactions = @current_user.transactions.limit(15).order('created_at DESC')
  end

  def show
	  @transaction = Transaction.find(params[:id])
  end

  def create
	  fullCategory = transaction_params[:category].split
	  @transaction = @current_user.transactions.new
	  @transaction.category = fullCategory[0]
	  @transaction.amount = fullCategory[1].to_i
	  @transaction.detail = fullCategory[2..-1].join(' ')
	  @transaction.save
	  @current_user.balance += @transaction.amount
	  @current_user.save
  	  redirect_to action: 'index'
  end

  def history
		history = @current_user.get_history(params[:begin], params[:end]).each_slice(16).to_a
		@maxPage = history.size
		@transactions = history[params[:page]? params[:page]-1 : 0]
  end

  def week
		@days = @current_user.get_week
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
