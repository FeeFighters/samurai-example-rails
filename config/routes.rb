Blog::Application.routes.draw do
  resources :articles do
    resources :orders, :only=>[:new] do
      get :purchase, :on=>:collection
    end
  end
  root :to => "articles#index"
end
