Blog::Application.routes.draw do
  resources :articles do
    resources :orders, :only=>[:create] do
      collection do
        get 'new_payment_method'
        get 'payment_confirmation'
      end
    end
  end
  root :to => "articles#index"
end
