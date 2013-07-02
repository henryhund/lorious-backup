Lorious::Application.routes.draw do
  get 'chat' => "chat#new"

  get "chat/test"

  get "chat/index"

  post "profiles/pre" => "profiles#create_before_signup"
  post "profiles/preup" => "profiles#update_before_signup"
  resources :profiles


  resources :requests

  # authenticated :user do
  #  root :to => 'requests#index'
  # end

  root :to => "home#landing_page"
  get 'welcome' => "home#more"
  # post 'welcome' => "requests#new"

  devise_for :users, :controllers => { :registrations => "registrations" } 
  resources :users

  devise_scope :user do
    get 'login' => "devise/sessions#new"
    get 'logout' => "devise/sessions#destroy"
  end

  get 'thanks' => "home#thanks"
  get 'confirmed' => "home#confirmed"

  get 'message' => "home#message"
  get '/:niche' => "home#landing_page"

  get 'chat/:session_id' => "chat#chat"

end