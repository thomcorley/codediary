Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
  	resources :entries
    resources :searches
  end

  get "/signin" => "users#signin"
  get "/intro" => "users#signin_with_google"
  get "/index_by_keyword" => "searches#index_by_keyword"
  get "/index_by_date" => "searches#index_by_date"
  get "/index_by_tag" => "searches#index_by_tag"
  get "/tags" => "searches#tags"
  get "/home" => "entries#home"
  get '/index' => "entries#index"
  get "/new" => "entries#new"
  get "/signin_with_github" => "users#signin_with_github"

  root 'welcome#index'

end
