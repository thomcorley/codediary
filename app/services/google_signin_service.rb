  class GoogleSigninService

  def get_user_params(code)
    # # Signs in using the Google API. Returns an array of User params

    @client_id = "794263904785-vea01ahfrk7glbtclgmu384tqvbsid5d.apps.googleusercontent.com"
    @client_secret = "R-Yvu-RIXpQ3HT0EKbQJ-RMl"
    @redirect_uri = "#{Rails.configuration.host}/intro"

    ap res = HTTParty.post("https://www.googleapis.com/oauth2/v4/token",
      body: {
        code: code,
        client_id: @client_id,
        client_secret: @client_secret,
        redirect_uri: @redirect_uri,
        grant_type: "authorization_code"
      }    
    )
    
    jwt = res["id_token"]
    jwt_array = jwt.split(".")
    jwt_body = jwt_array[1]
    jwt_parsed = Base64.decode64(jwt_body)
    decoded = JSON.parse(jwt_parsed)

    name = decoded["name"]
    email = decoded["email"]

    user_params = {
      "first_name" => name.split[0],
      "last_name" => name.split[1],
      "email_address" => decoded["email"]
    }

    end

  end
