Rails.application.routes.draw do
  root 'groups#index'
  devise_for :users

  resources :groups do
    post '/join', as: :member, to: 'groups#join'
    delete '/remove', to: 'groups#remove'
    resources :posts do
      resources :comments, shallow: true do 
        resources :replies
      end
    end
  end
end
