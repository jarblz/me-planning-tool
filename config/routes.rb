Rails.application.routes.draw do


  root 'home#index'

  devise_for :users, controllers: {
    :invitations => 'admin/invitations',
  }
  namespace 'admin' do
    resources :users, controller: 'users'
    resources :diseases
    resources :projects do
      resources :indicators
    end
  end

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  get 'home/countries' => 'home#countries'

  get 'countries/:country_id/project/:project_id' => 'projects#show', as: 'project'
  get 'countries/:id' => 'countries#show', as: 'country'
end
