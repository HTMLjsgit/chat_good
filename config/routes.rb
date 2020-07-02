Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
  
  }
  root 'tops#index'
  get 'rooms/:id/password' => 'rooms#password_edit', as: "room_password"
  put 'rooms/:id/passwords' => 'rooms#password_update', as: "room_password_update"
  get 'rooms/:id/password_certification' => 'rooms#room_certification', as: "room_certification"
  post 'rooms/:id/password_certifications' => 'rooms#room_certification_create', as: "room_certifications"
  resources :rooms do
    resources :usermanagers
  end
  resources :messages
  get '*path', to: 'application#render_404'
  get '*path', to: 'application#render_500'
  resources :users, only: [:show, :edit, :update]
  # get 'rooms/:id/usermanagers/:id/messages' => 'rooms#usermessages', as: "room_user_messages"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
