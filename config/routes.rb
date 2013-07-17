Lorious::Application.routes.draw do
  resources :reviews


  resources :appointments

  get 'faq' => 'home#faq'

  # get 'chat' => "chat#new"

  # chat routes
  get "chat/test" => "chat#test"
  get 'chat/go/:user_id/:chat_key' => "chat#chat_prep"
  get 'chat/go/:user_id/:chat_key/start' => "chat#scheduled_chat"
  get 'chat/go/:user_id/:chat_key/register' => "users#finish_registration"
  get 'chat/go/:user_id/:chat_key/error' => "home#error"
  get 'chat/go/:user_id/:chat_key/end' => "chat#chat_end"

  # get "chat/index"

  post 'chat/report_listener' => "chat#report_listener"

  # custom signup routes for waiting list signup
  put 'finish_pre_registration' => "users#edit_incomplete_registration"
  post "profiles/pre" => "profiles#create_before_signup"
  post "profiles/preup" => "profiles#update_before_signup"
  get 'welcome' => "home#more"
  get 'confirmed' => "home#confirmed"

  devise_for :users #, :controllers => { :registrations => "registrations" } 
  resources :users
  devise_scope :user do
    get 'login' => "devise/sessions#new"
    get 'logout' => "devise/sessions#destroy"
  end

  get '/:id/avatar' => "users#upload_avatar"

  resources :profiles
  resources :requests

  root :to => "home#landing_page"

  # authenticated :user do
  #  root :to => 'requests#index'
  # end

  
  get '/:id' => "users#show"

end