Lorious::Application.routes.draw do
  



  resources :transactions


  # basic public routes
  authenticated :user do
    root :to => 'users#dashboard'
  end
  get "/users/:id/dashboard" => "users#dashboard", as: "user_dashboard"
  get "/accounts" => "users#manage_payments", as: "manage_payments"
  get "/packages" => "home#credit_packages", as: "credit_packages"

  post "/packages/cart" => "credits#credits_cart", as: "credits_pre"

  post "/packages/card/buy" => "credits#buy_credits", as: "buy_credits"

  root :to => "home#audience_home"
  
  get 'blog_home' => "home#blog_home"
  get 'expert' => 'home#blog_home'
  get 'experts' => 'home#blog_home'
  get 'audience' => 'home#audience_home'
  get 'faq' => 'home#faq'
  get 'legal' => 'home#legal'

  get 'confirmed' => "home#confirmed"
  post 'confirmed' => "home#confirmed"

  resources :reviews
  resources :profiles
  resources :requests
  resources :charges
  resources :customers
  resources :credits

  resources :services

  scope '/:id' do
    resources :appointments
    resources :recipients
    resources :cards
  end

  # devise_for :users #, :controllers => { :registrations => "registrations" } 
  devise_for :users, :controllers => { :registrations => "registrations", :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :users
  devise_scope :user do
    get 'login' => "devise/sessions#new"
    get 'logout' => "devise/sessions#destroy"
    get 'signup' => "devise/registrations#new"
  end

  resources :conversations, only: [:index, :show, :new, :create] do
    member do
      post :reply
      post :trash
      post :untrash
    end
  end

  # chat routes
  get "chat/test" => "chat#test"
  # get 'chat/go/:user_id/:chat_key' => "chat#chat_prep"
  get 'chat/go/:chat_key/' => "chat#scheduled_chat", as: "chat_start"
  # get 'chat/go/:user_id/:chat_key/register' => "users#finish_registration"
  # get 'chat/go/:chat_key/error' => "home#error"
  get 'chat/go/:chat_key/end' => "chat#chat_end"

  # chat listener for determining conversation length
  post 'chat/report_listener' => "chat#report_listener"

  # custom signup routes for waiting list signup
  # put 'finish_pre_registration' => "users#edit_incomplete_registration"
  # post "profiles/pre" => "profiles#create_before_signup"
  # post "profiles/preup" => "profiles#update_before_signup"

  # authenticated :user do
  #  root :to => 'requests#index'
  # end

  # get 'message' => "home#message"
  # get '/:niche' => "home#audience_home"

  # user/profile show and edit routes
  get '/:id' => "users#show", as: "user_page"  
  get '/:id/avatar' => "users#upload_avatar", as: "avatar_page"
  get '/:id/expert' => "users#make_expert", as: "expert_approval"
  get '/:id/message' => "conversations#message", as: "message_user"
  # put '/avatars' => "users#update_avatar"

  


end