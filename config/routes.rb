Lorious::Application.routes.draw do
  resources :requests

  authenticated :user do
    root :to => 'requests#index'
  end

  root :to => "home#landing_page"
  get 'welcome' => "requests#new"

  devise_for :users
  resources :users

  devise_scope :user do
    get 'login' => "devise/sessions#new"
    get 'logout' => "devise/sessions#destroy"
  end

  get 'thanks' => "home#thanks"
  get 'confirmed' => "confirmed"
end