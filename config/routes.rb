Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users
  resources :beers
  resources :breweries
  resources :ratings, only: [:index, :new, :create, :destroy]
  root 'breweries#index'
  get 'ratings', to: 'ratings#index'
  get 'ratings/new', to: 'ratings#new'
  post 'ratings', to: 'ratings#create'
  get 'signup', to: 'users#new'
  
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'

  resource :session, only: [:new, :create, :destroy]

  resources :memberships, only: [:new, :create]
  
  resources :places, only: [:index, :show]
  post 'places', to: 'places#search'

  resources :styles

  resources :breweries do
    post 'toggle_activity', on: :member
  end

  resources :users do
    member do
      post :close_account
      post :open_account
    end
  end

end
