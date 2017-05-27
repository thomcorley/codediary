Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
  	resources :entries
    resources :searches
  end

  get "/signin" => "users#signin"
  get "/intro" => "users#signin"
  get "/search_by_keyword" => "searches#by_keyword"
  get "/search_by_date" => "searches#by_date"
  get "/search_by_tag" => "searches#by_tag"
  get "/tags" => "searches#tags"
  get "/home" => "entries#home"
  get '/index' => "entries#index"
  get "/new" => "entries#new"

  root 'welcome#index'

end
