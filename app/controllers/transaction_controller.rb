class TransactionController < ApplicationController
	before_filter :authorize
	skip_before_filter :authorize, only: ['frontpage']
	
  def frontpage
  end
	
  def index
	  if current_user
		  @transaction = @current_user.transactions.new
		  #@transactions = @current_user.transactions.limit(15)
	  	  @transactions = Transaction.all()
	  else
		  redirect_to 'frontpage'
	  end
  end

  def show
	  @transaction = Transaction.find(params[:id])
  end

  def create
	  fullCategory = transaction_params[:category].split
	  @transaction = Transaction.new
	  @transaction.category = fullCategory[0]
	  @transaction.amount = fullCategory[1].to_i
	  @transaction.detail = fullCategory[2]
	  @transaction.save
	  #Transaction.create(transaction_params)
  	  redirect_to(action: 'index')
  end

  def history
	  @transactions = Transaction.all()
  end

  def week
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
