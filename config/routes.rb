Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    unlocks: 'users/unlocks'
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
  	resources :entries
    resources :searches
  end

  get "/signin" => "users#signin"
  get "/intro" => "users#signin"
  get "/index_by_keyword" => "searches#index_by_keyword"
  get "/index_by_date" => "searches#index_by_date"
  get "/index_by_tag" => "searches#index_by_tag"
  get "/tags" => "searches#tags"
  get "/home" => "entries#home"
  get '/index' => "entries#index"
  get "/new" => "entries#new"

  root 'welcome#index'

end
