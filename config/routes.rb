Rails.application.routes.draw do
  devise_for :users
  resources :grievances

  root 'grievances#index'
  get '/cities/(:state)', to: 'application#cities'
  get '/cops/search', to: 'application#cops'
  patch '/cops/new', to: 'application#cops_create', as: :create_cop
  get '/connected-grievances/search', to: 'application#connected_grievances'
  get '/my-grievances/(:page)', to: 'grievances#my_grievances', as: :my_grievances
  get '/new-grievances/(:page)', to: 'grievances#new_grievances', as: :new_grievances
  get '/changed-grievances/(:page)', to: 'grievances#changed_grievances', as: :changed_grievances
  get '/search', to: 'grievances#search', as: :search
  get '/grievances/:id/approve', to: 'grievances#approve', as: :approve_grievance
  get '/grievances/:id/disapprove', to: 'grievances#disapprove', as: :disapprove_grievance

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
