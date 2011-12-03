Blog::Application.routes.draw do

  # Samurai.js routes
  scope '/samurai-js', :controller=>:samurai_js, :as=>:samurai_js do
    get :payment_form
    post :purchase
    get :receipt
  end

  # Transparent Redirect routes
  scope '/transparent-redirect', :controller=>:transparent_redirect, :as=>:transparent_redirect do
    get :payment_form
    get :purchase  # GET, because Samurai will redirect the browser back to this URL
    get :receipt
  end

  # Server-to-Server routes
  scope '/server-to-server', :controller=>:server_to_server, :as=>:server_to_server do
    get :payment_form
    post :purchase
    get :receipt
  end

  root :to => "demo#index"

end
