Rails.application.routes.draw do
  # devise_for :users
  devise_scope :user do
    get "profile", to: "home#profile"
  end
  devise_for :users, controllers: {
    invitations: 'users/invitations'
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")


    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    namespace :api do
      namespace :v1 do 
        devise_scope :user do
          post "sign_up", to: "registrations#create"
          post "sign_in", to: "sessions#create"
          post 'forgot_password', to: 'passwords#forgot_password'
          post 'reset_password', to: 'passwords#reset_password'
          put 'change_password', to: 'passwords#change_password'
          post "confirm_email", to: "confirmations#confirm_email"
          post "send_invitation", to: "invitations#send_invitation"
          post "send_reinvitation", to: "invitations#send_reinvitation"
          post "accept_invitation", to: "invitations#accept_invitation"
          delete "logout", to: "sessions#logout"
          get "profile", to: "sessions#profile"
        end
  
        # Custom routing error path
        match '*path', to: 'base#routing_error', via: %i[get post put patch delete]
        root to: 'base#routing_error'
      end
    end
    root to: 'home#index'

end
