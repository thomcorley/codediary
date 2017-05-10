class EntriesController < ApplicationController

  require "net/http"
  require 'httparty'
  require 'json'
  require 'base64'
  require 'ap'

  def index
    @user = User.find(params[:user_id])
    @entries = @user.entries.all.order("created_at DESC")
  end

  def show
    @user = User.find(params[:user_id])
    p params
    @entry = @user.entries.find(params[:id])
    @tags = @entry.tags.upcase.split
  end

  def new
    @user = User.find(params[:user_id])
    @entry = @user.entries.new
  end

  def edit
    @user = User.find(params[:user_id])
    @entry = @user.entries.find(params[:id])
  end

  def create
    @user = User.find(params[:user_id])

    @entry = @user.entries.create(entry_params)

    if @entry.save
      redirect_to user_entry_path(@user, @entry)
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

  end

  def intro

  end

  private
  def entry_params
    params.require(:entry).permit(:title, :content, :tags)
  end
end
