class UsersController < ApplicationController

  require "httparty"
  require "securerandom"
  require "awesome_print"
  require "rack"
  require "pry"
  require "date"
  require "base64"
  require "json"
  require "redcarpet"
  require "google_signin_service"
  require "markdown_service"

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
    @greeting = get_greeting
  end

  private
  def get_greeting
    now = DateTime.now

    if now.between?(DateTime.parse("17:00"), DateTime.parse("23:59"))
      @greeting = "Good evening"
    elsif now.between?(DateTime.parse("00:00"), DateTime.parse("12:00"))
      @greeting = "Good morning"
    else now.between?(DateTime.parse("12:00"), DateTime.parse("17:00"))
      @greeting = "Good afternoon"
    end

    @greeting
  end

end
