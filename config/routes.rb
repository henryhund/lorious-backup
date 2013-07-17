Lorious::Application.routes.draw do
  
  get 'expert' => 'home#blog_home'
  get 'experts' => 'home#blog_home'
  get 'audience' => 'home#audience_home'

  get 'legal' => 'home#legal'



  resources :reviews


  resources :appointments

  get 'faq' => 'home#faq'

  get 'chat' => "chat#new"

  get "chat/test" => "chat#test"

  get 'chat/go/:user_id/:chat_key' => "chat#chat_prep"
  get 'chat/go/:user_id/:chat_key/start' => "chat#scheduled_chat"
  get 'chat/go/:user_id/:chat_key/register' => "users#finish_registration"
  get 'chat/go/:user_id/:chat_key/error' => "home#error"
  
  get 'chat/go/:user_id/:chat_key/end' => "chat#chat_end"

  get "chat/index"

  post 'chat/report_listener' => "chat#report_listener"

  put 'finish_pre_registration' => "users#edit_incomplete_registration"

  post "profiles/pre" => "profiles#create_before_signup"
  post "profiles/preup" => "profiles#update_before_signup"
  resources :profiles


  resources :requests

  # authenticated :user do
  #  root :to => 'requests#index'
  # end

  root :to => "home#audience_home"
  get 'welcome' => "home#more"
  get 'blog_home' => "home#blog_home"
  # post 'welcome' => "requests#new"

  devise_for :users, :controllers => { :registrations => "registrations" } 
  resources :users

  devise_scope :user do
    get 'login' => "devise/sessions#new"
    get 'logout' => "devise/sessions#destroy"
  end

  # get 'thanks' => "home#thanks"
  get 'confirmed' => "home#confirmed"
  post 'confirmed' => "home#confirmed"

  get 'message' => "home#message"
  get '/:niche' => "home#audience_home"

  # get 'chat/:session_id' => "chat#chat"

end