Rails.application.routes.draw do

  root 'home#index'

  devise_for :users, controllers: {
    :invitations => 'admin/invitations',
  }
  namespace 'admin' do
    resources :users, controller: 'users'
  end


end
