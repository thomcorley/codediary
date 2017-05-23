class UsersController < ApplicationController

  require "httparty"
  require "securerandom"
  require "awesome_print"
  require "rack"
  require "pry"
  require "date"

  def show
    @user = User.find(params[:id])
    @entries = @user.entries

    now = DateTime.now

    if now.between?(DateTime.parse("17:00"), DateTime.parse("23:59"))
      @greeting = "Good evening"
    elsif now.between?(DateTime.parse("00:00"), DateTime.parse("12:00"))
      @greeting = "Good morning"
    else now.between?(DateTime.parse("12:00"), DateTime.parse("17:00"))
      @greeting = "Good afternoon"
    end

  end

  def intro
    @client_id = "85887f1a18dd3c5d43fe"
    @client_secret = "28d5ed3ad4f614802ed419322c487e2d3329b342"
    @redirect_uri = "http://www.codediary.co/intro"
    @state = "6b41778eec044a860b93f204e3418ded"
    @allow_signup = false

    code = params["code"]
    state = params["state"]

    res = HTTParty.post(
      "https://github.com/login/oauth/access_token",
      :query => {
        "client_id" => @client_id,
        "client_secret" => @client_secret,
        "code" => code,
        "redirect_uri" => @redirect_uri,
        "state" => @state
        })

    response_hash = Rack::Utils.parse_nested_query(res)
    access_token = response_hash["access_token"]

    res = HTTParty.get("https://api.github.com/user",
      :headers => {
        "User-Agent" => "codediary"
      },
      :query => {
        "access_token" => access_token
      })

    unless res["name"].nil?
      name = res["name"]

      user_params = {
        "first_name" => name.split[0],
        "last_name" => name.split[1],
        "email_address" => res["email"]
      }
    end

    email = user_params["email_address"]

    @user = User.new(user_params)

    if User.where(email_address: email).exists?
      user = User.find_by_email_address email
      redirect_to "/users/#{user.id}"
    elsif
      @user.save
      redirect_to "/users/#{@user.id}"
    end

    def signin_with_google
      @client_id = "794263904785-vea01ahfrk7glbtclgmu384tqvbsid5d.apps.googleusercontent.com"
      @client_secret = "R-Yvu-RIXpQ3HT0EKbQJ-RMl"
      @redirect_uri = "http://localhost:3000/intro"

      ap res HTTParty.get("https://accounts.google.com/o/oauth2/v2/auth",
        query: {
          client_id: @client_id,
          client_secret: @client_secret,
          scope: "email",
          redirect_uri: @redirect_uri,
          state: "state",
        })


    end



















  end
end
