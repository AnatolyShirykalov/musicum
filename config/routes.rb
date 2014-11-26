Rails.application.routes.draw do
  resources :performs

  devise_for :users
  resources :composers do
    resources :pieces
  end
  match '/listen', to: 'halls#invite', via: 'get'
  match '/filter', to: 'halls#filter', via: 'post'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Ckeditor::Engine => '/ckeditor'
  #mount Uploader::Engine => '/uploader'
  match '/tt', to: 'composers#tt', via: 'get'
  match 'audio', to: 'audios#index', via: 'get'

  get 'contacts' => 'contacts#index', as: :contacts
  post 'contacts' => 'contacts#create', as: :create_contacts
  get 'contacts/sent' => 'contacts#sent', as: :contacts_sent

  get 'search' => 'search#index', as: :search

  resources :news, only: [:index, :show]

  root to: 'welcome#index'

  get '*slug' => 'pages#show'
  resources :pages, only: [:show]
end
