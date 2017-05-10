class EntriesController < ApplicationController
  require "net/http"
  require 'httparty'
  require 'json'
  require 'base64'
  require 'ap'

  http_basic_authenticate_with name: "thomcorley", password: "Thom4s2017"

  def index
    @entries = Entry.all.order("created_at DESC")
  end


  def show
    @entry = Entry.find(params[:id])
    @tags = @entry.tags.upcase.split
  end

  def new
    @entry = Entry.new
  end

  def edit
    @entry = Entry.find(params[:id])
  end

  def create
    @entry = Entry.new(entry_params)

    if @entry.save
      redirect_to @entry
    else
      render :new
    end
  end

  def update
    @entry = Entry.find(params[:id])

    if @entry.update(entry_params)
      redirect_to @entry
    else
      render :edit
    end
  end

  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy

    redirect_to :index
  end

  def dates
    entries = Entry.all
    $dates_array = Array.new
    entries.each do |entry|
      $dates_array << entry.created_at.strftime("%Y-%m-%d")
    end
    $dates_array.uniq
  end

  def index_by_tag
    entries = Entry.all
    @selected_entries = Array.new
    entries.each do |entry|
      if entry.tags.include? params[:tag]
        @selected_entries << entry
      end
    end
    @selected_tag = params[:tag]
  end

  def index_by_date
    entries = Entry.all
    @selected_entries = Array.new
    @selected_date = params[:selected_date]
    entries.each do |entry|
      if @selected_date == entry.created_at.strftime("%Y-%m-%d")
        @selected_entries << entry
      end
    end
    @selected_entries
  end

  def index_by_keyword
    entries = Entry.all
    @selected_entries = Array.new
    @keyword = params[:keyword]
    entries.each do |entry|
      if /#{@keyword}/.match(entry.content) ||
        /#{@keyword}/.match(entry.tags) ||
        /#{@keyword}/.match(entry.title)
        @selected_entries << entry
      end
    end
    logger.debug "hello"
  end

  def tags
    entries = Entry.all
    # Create a list of all the tags, as a String
    tags_list = String.new
    entries.each do |entry|
      tags_list << entry.tags + " "
    end
    # Convert the String to a global array, removing the duplicate elements
    $tags_array = tags_list.split.uniq
  end

  def home
    client_id = "893363579239-rn43pc0jlnnad5gmgu24ci0uhvvbo9sp.apps.googleusercontent.com"
    client_secret = "tTNRZcW1US33GDfIUhOpMGQo"
    code = params[:code]

    params = {
      :client_id => client_id,
      :code => code,
      :client_secret => client_secret,
      :redirect_uri => "http://localhost:3000/home",
      :grant_type => "authorization_code"
    }
    base_uri = "https://www.googleapis.com/oauth2/v4/token?"
    query = params.to_query
    full_path = base_uri + query

    response = HTTParty.post(full_path)
    body_hash = JSON.parse(response.body)
    p jwt = body_hash["id_token"]
    jwt = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjdjODNmNWNjMTUzNjAwMzczN2MzNzU5YjJiOTBiMWE1ZDFkNGFjNjUifQ.eyJhenAiOiI4OTMzNjM1NzkyMzktcm40M3BjMGpsbm5hZDVnbWd1MjRjaTB1aHZ2Ym85c3AuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI4OTMzNjM1NzkyMzktcm40M3BjMGpsbm5hZDVnbWd1MjRjaTB1aHZ2Ym85c3AuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDkwMzAzMjM2NjA1NjE5MDQ0OTgiLCJlbWFpbCI6InRob21jb3JsZXlAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJzSGpsVmZuaVNudnFiSEpMWG1pYXh3IiwiaXNzIjoiaHR0cHM6Ly9hY2NvdW50cy5nb29nbGUuY29tIiwiaWF0IjoxNDkwOTQ5NzA3LCJleHAiOjE0OTA5NTMzMDcsIm5hbWUiOiJUb20gQ29ybGV5IiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS8tem1yTTBpODFQblEvQUFBQUFBQUFBQUkvQUFBQUFBQUFBaDAvVWxhNEJfdmhQRFUvczk2LWMvcGhvdG8uanBnIiwiZ2l2ZW5fbmFtZSI6IlRvbSIsImZhbWlseV9uYW1lIjoiQ29ybGV5IiwibG9jYWxlIjoiZW4tR0IifQ.GuyPYEmBC9Yb0tz0_DmTmEJ4don8IyM0K-olY_By7i1c9nTPpH_b2Hma1007kNqWpnpOg2t2n9lTvOfqhgBNapoKwbzv80b4UDkZ_G96IwOKEdekMNGKltmDpiMwbgoWxEFBFr1jL854RbdO0AnrLm1MfUqp4gR5WSO5s95FpUJEh9GO-yJD7wvbO5DnY_Pa-I09XK_n4wLRm45dAM0hlkUN2gIReYotkUjdUK15T7uD1me5sdxJgtJLdCC86-9ixfTOV2iVLnzB_jhs4kHP2LI23td_NWMv_YQ6L-3FziICQRJuYknaBYPR8dau8JIQI4rlIKc6IlTcnVvuXua_pQ"
    jwt_array = jwt.split(".")
    jwt_payload = Base64.decode64(jwt_array[1])
    payload = JSON.parse(jwt_payload)
    ap payload
  end

  def intro

  end

  private
  def entry_params
    params.require(:entry).permit(:title, :content, :tags)
  end
end
