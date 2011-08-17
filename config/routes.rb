Blog::Application.routes.draw do
  resources :articles do
    get 'payment_method' => "orders#payment_method"
    get 'transaction' => "orders#transaction"
    resources :orders, :only=>[:create]
  end
  root :to => "articles#index"
end
