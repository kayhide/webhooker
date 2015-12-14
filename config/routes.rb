Webhooker::Engine.routes.draw do
  root to: 'subscribers#index'
  resources :subscribers, only: [:index, :create, :destroy]
end
