Churchof::Application.routes.draw do
  get "church_admin_panel/index"
  get "need_poster_panel/index"
  get "user_panel/index"
  get "user_panel/new"
  get "user_panel/create"
  get "users/index"
  get "users_controller/index"
  get "profiles/show"
  post "needs/create_charge"
  post "needs/set_is_public"
  devise_for :users

  devise_scope :user do
    get 'register', to: 'devise/registrations#new', as: :register
    get 'login', to: 'devise/sessions#new', as: :login
  end

  resources :users # Not sure if this is ok to do with Devise also.

  resources :needs do
    resources :contributions
  end

  # The following was proposed by Todd Willey and adds it as a subroute.
  # resources :needs do
  #   post :create_charge
  # end

  get 'feed', to: 'needs#index', as: :feed

  root :to => 'needs#index'

  get '/:id', to: 'profiles#show'

  # Added for create_charge method.
  # resources :needs, :member => {:create_charge => :post}

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
