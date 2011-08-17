Blog::Application.routes.draw do
  get "orders#payment_method"
  get "orders#transaction"
  get "orders#show"

  resources :articles
  root :to => "articles#index"
end
