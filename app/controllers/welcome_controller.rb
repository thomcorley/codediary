class WelcomeController < ApplicationController
  def index
    @client_id = "794263904785-vea01ahfrk7glbtclgmu384tqvbsid5d.apps.googleusercontent.com"
    @client_secret = "R-Yvu-RIXpQ3HT0EKbQJ-RMl"
    @redirect_uri = "http://www.codediary.co/intro"
  end
end
