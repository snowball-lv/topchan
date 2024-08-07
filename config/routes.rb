Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get "/boards", to: "boards#index"
  get "/boards/:id", to: "boards#show"

  get "/threads/:board/:no", to: "chan_threads#show"

  get "/posts/:board/:thread/:post", to: "posts#show"

end
