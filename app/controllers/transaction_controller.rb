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
		@transaction = Transaction.build_transaction transaction_params[:detail]
		@current_user.transactions << @transaction
	  @transaction.save
	  @current_user.balance += @transaction.amount
	  @current_user.save
  	redirect_to action: 'index'
  end

  def history
		history = @current_user.get_history(params[:begin], params[:end]).each_slice(16).to_a
		@actualPage = params[:page]? params[:page].to_i-1 : 0;
		@maxPage = history.size
		@dates = 'begin='+params[:begin].to_s+'&end='+params[:end].to_s
		@transactions = history[@actualPage]
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
