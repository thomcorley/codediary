class UsersController < ApplicationController

  require "httparty"
  require "securerandom"
  require "awesome_print"
  require "rack"
  require "pry"

  def show
    @user = User.find(params[:id])

  end

  def intro
    @client_id = "85887f1a18dd3c5d43fe"
    @client_secret = "28d5ed3ad4f614802ed419322c487e2d3329b342"
    @redirect_uri = "http://localhost:3000/intro"
    # SecureRandom.hex
    # SecureRandom.base64
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

    ap @user = User.new(user_params)

    if User.where(email_address: email).exists?
      user = User.find_by_email_address email
      redirect_to "/users/#{user.id}"
    elsif
      @user.save
      redirect_to "/users/#{@user.id}"
    end


  end
end
