Rails.application.routes.draw do


  get 'password_resets/new'

  get 'password_resets/edit'

  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  
  get  '/makeredirect',  to: 'urls#new'
  post '/makeredirect',  to: 'urls#create'  
  
  resources :urls

 
  resources :users, only: [:new, :create, :edit, :update, :show, :destroy]
  

  resources :changeplans, only: [:edit, :update]


  resources :subscribers
  

  
  post '/stripe/webhooks', to: "stripe#webhooks"





  
  
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

end