class TransactionController < ApplicationController
	
  def index
	  @transaction = Transaction.new
	  @transactions = Transaction.all().limit(15)
  end

  def show
	  @transaction = Transaction.find(params[:id])
  end

  def create
	  fullCategory = transaction_params
	  fullCategory.split!(' ')
	  #Transaction.create(transaction_params)
  	  #redirect_to(:index)
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
