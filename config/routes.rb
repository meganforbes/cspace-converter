Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'sites#index'

  get  'authorities',              to: 'authority_objects#index'
  get  'authorities/:id',          to: 'authority_objects#show', as: 'authority'
  post 'authorities/:id/ping',     to: 'authority_objects#ping'
  post 'authorities/:id/delete',   to: 'authority_objects#delete'
  post 'authorities/:id/ping',     to: 'authority_objects#ping'
  post 'authorities/:id/transfer', to: 'authority_objects#transfer'
  post 'authorities/:id/update', to: 'authority_objects#update'

  get 'batches', to: 'batches#index'

  get 'connection', to: "sites#connection", as: 'connection'

  get  'import', to: 'imports#new'
  post 'import', to: 'imports#create'

  get 'objects',     to: 'data_objects#index'
  get 'objects/:id', to: 'data_objects#show', as: 'object'

  get  'procedures',              to: 'procedure_objects#index'
  get  'procedures/:id',          to: 'procedure_objects#show', as: 'procedure'
  post 'procedures/:id/delete',   to: 'procedure_objects#delete'
  post 'procedures/:id/ping',     to: 'procedure_objects#ping'
  post 'procedures/:id/transfer', to: 'procedure_objects#transfer'
  post 'procedures/:id/update', to: 'procedure_objects#update'

  post 'nuke', to: 'sites#nuke', as: 'nuke'

  get  'relationships',              to: 'relationship_objects#index'
  get  'relationships/:id',          to: 'relationship_objects#show', as: 'relationship'
  post 'relationships/:id/ping',     to: 'relationship_objects#ping'
  post 'relationships/:id/delete',   to: 'relationship_objects#delete'
  post 'relationships/:id/ping',     to: 'relationship_objects#ping'
  post 'relationships/:id/transfer', to: 'relationship_objects#transfer'

  get  'transfer', to: 'transfers#new'
  post 'transfer', to: 'transfers#create'

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
