class UsersController < ApplicationController

  require "httparty"
  require "securerandom"
  require "awesome_print"
  require "rack"

  def index
    p params
  end

  def new

  end

  def create

  end

  def show
    p @user = User.find(params[:id])
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

    name = res["name"]

    user_params = {
      "first_name" => name.split[0],
      "last_name" => name.split[1],
      "email_address" => res["email"]
    }

    @user = User.new(user_params)
    @user.save

		render "show"
	end

  # private
  # def user_params
  #   params.require(:user).permit(:first_name, :last_name, :email)
  # end

	def signin
		client_id = "893363579239-rn43pc0jlnnad5gmgu24ci0uhvvbo9sp.apps.googleusercontent.com"
		client_secret = "tTNRZcW1US33GDfIUhOpMGQo"


		params = {
			:client_id => client_id,
			:response_type => "code",
			:scope => "openid email profile",
			:redirect_uri => "http://localhost:3000/home",
			:state => "another_password",
			:login_hint => "thomcorley@gmail.com"
		}

		base_uri = "https://accounts.google.com/o/oauth2/v2/auth?"
		query = params.to_query
		$uri = URI(base_uri + query)
	end

end
