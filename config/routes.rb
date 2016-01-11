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
      resources :tools
    end
  end
  get 'admin/global_indicators' => "admin/indicators#edit_global", as: 'global_indicators'
  get 'admin/global_indicators/:id' => "admin/indicators#save_global", as: 'save_global_indicators'

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  get 'home/countries' => 'home#countries'

  get 'countries/:country_id/project/:project_id' => 'projects#show', as: 'project'
  get 'countries/:id' => 'countries#show', as: 'country'

  get 'countries/country/projects' => 'countries#projects', as: 'country_projects'


end
