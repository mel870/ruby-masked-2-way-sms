Rails.application.routes.draw do
  resources :messages

  resources :agents

  resources :customers

  root 'agents#index'


end
