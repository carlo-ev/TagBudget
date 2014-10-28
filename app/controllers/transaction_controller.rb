class TransactionController < ApplicationController
	
  def index
	  @transactions = Transaction.all().limit(15)
  end

  def show
	  @transaction = Transaction.find(params[:id])
  end

  def create
	  Transaction.create(transaction_params)
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
