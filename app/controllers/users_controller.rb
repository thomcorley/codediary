class UsersController < ApplicationController

  require "google_signin_service"
  require "greeting_service"

  def signin
    user_params = GoogleSigninService.new.get_user_params(params["code"])
    email = user_params["email_address"]
    @user = User.new(user_params)

    if User.where(email_address: email).exists?
      user = User.find_by_email_address email
      redirect_to "/users/#{user.id}"
    elsif
      @user.save
      redirect_to "/users/#{@user.id}"
    end
  end

  def show
    @user = User.find(params[:id])
    @entries = @user.entries
    ap @greeting = GreetingService.new.greeting
  end

end
