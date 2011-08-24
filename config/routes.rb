Blog::Application.routes.draw do
  resources :articles do
    get 'samurai' => "orders#samurai"
  end
  root :to => "articles#index"
end
