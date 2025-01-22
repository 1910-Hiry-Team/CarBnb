Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # # root "posts#index"
  # resources :bookings, path: "/cars/:car_id/booking/new", except: :index
  # resources :bookings, path: "/host/:user_id", only: [:index, :show, :edit, :update]
  # resources :cars do
  #   resources :bookings, only: :new
  # end
  # root "posts#index"
  resources :users do
    resources :cars
    resources :bookings
    # resources :cars
  end
  resources :cars, only: [:index, :show] do
    collection do
      get :search
    end
  end
end
