class UserController < ApplicationController
	def new
		@user = User.new
	end
	
	def create
		user = User.new(user_params)
		user.balance = 0
		if	user.save
			session[:user_id] = user.id
			redirect_to '/transaction', :notice => 'Signed Up!'
		else
			render 'new'
		end
	end

	private
	def user_params
		params.require(:user).permit(:email, :password, :password_confirmation)
	end
	
end