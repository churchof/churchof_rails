Churchof::Application.routes.draw do
  resources :updates

  # get "whatever", to: "posts#show"
  # get "whatever/:name", to: "posts#show"
  # link_to "My Link", whatever_path(name: "Jack")
  get "church_admin_panel/index"
  get "need_poster_panel/index"
  get "need_leader_panel/index"
  get "impact_panel/index"
  get "validation_partner_panel/index"
  get "organization_resource_validation_partner_panel/index"
  get "resource_partner_panel/index"
  get "user_panel/index"
  get "user_panel/new"
  get "user_panel/create"
  get "users/index"
  get "users_controller/index"
  post "needs/create_charge"
  post "needs/set_is_public"
  post "users/agree_to_need_poster_agreement"
  post "users/agree_to_need_leader_agreement"
  post "users/agree_to_church_admin_agreement"
  post "users/add_user_as_resource_partner"
  post "resources/take_over_management"
  post "users/remove_user_as_resource_partner"
  get '/beta' => 'pages#beta'
  get '/contribution_terms' => 'pages#contribution_terms'
  get '/volunteering_terms' => 'pages#volunteering_terms'
  get '/skills_list' => 'pages#skills_list'
  get '/contribution_succeeded' => 'pages#contribution_succeeded'
  get '/contribution_failed' => 'pages#contribution_failed'
  get '/contribution_succeeded_account_invite' => 'pages#contribution_succeeded_account_invite'
  devise_for :users

  devise_scope :user do
    get 'register', to: 'devise/registrations#new', as: :register
    get 'login', to: 'devise/sessions#new', as: :login
  end

  resources :activities, only: [:create]

  resources :logs

  resources :users # Not sure if this is ok to do with Devise also.

  resources :skills
  resources :organizations
  resources :resources

  resources :organization_roles


  resources :needs do
    resources :contributions
    resources :time_contributions
    resources :expenses
    resources :skills
    resources :updates
  end

  # The following was proposed by Todd Willey and adds it as a subroute.
  # resources :needs do
  #   post :create_charge
  # end

  get 'feed', to: 'needs#index', as: :feed

  root :to => 'needs#index'


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
