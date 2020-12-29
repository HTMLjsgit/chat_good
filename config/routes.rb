Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
  
  }
  resources :notifications
  
  root 'tops#index'
  get 'rooms/:id/password' => 'rooms#password_edit', as: "room_password"
  get 'rooms/:room_id/messages/:id/download' => 'messages#download', as: "message_file_download"
  get 'rooms/:room_id/messages/:id/messages_replies/download' => 'message_replies#download', as: "message_reply_download"
  put 'rooms/:id/passwords' => 'rooms#password_update', as: "room_password_update"
  get 'rooms/:id/password_certification' => 'rooms#room_certification', as: "room_certification"
  post 'rooms/:id/password_certifications' => 'rooms#room_certification_create', as: "room_certifications"
  get 'rooms/:id/explanation' => 'rooms#explanation', as: "room_explanation"
  resources :rooms do
    resources :usermanagers
  end
  resources :messages
  resources :message_replies
  resources :users, only: [:show, :edit, :update]
  get '*path', to: 'application#render_404'
  get '*path', to: 'application#render_500'
  post 'notifications/check_save' => 'notifications#check_save', as: "check_save_notice"
  # get '*path'は　最後の行じゃないと、バグが起こるから注意しよう
  
  # get 'rooms/:id/usermanagers/:id/messages' => 'rooms#usermessages', as: "room_user_messages"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
