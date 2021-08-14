Rails.application.routes.draw do
  resources :meetings, only: [:index, :create, :show]
  patch 'meetings/:id', to: 'meetings#cancel', as: 'cancel_meeting'
end
