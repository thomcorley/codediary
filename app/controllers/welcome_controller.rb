class WelcomeController < ApplicationController
  def index
    @client_id = "85887f1a18dd3c5d43fe"
    @client_secret = "28d5ed3ad4f614802ed419322c487e2d3329b342"
    @redirect_uri = "https://intense-sierra-15257.herokuapp.com/intro"
    @state = "6b41778eec044a860b93f204e3418ded"
    @allow_signup = false
  end
end
