Rails.application.routes.draw do
<<<<<<< HEAD
  get 'company/login'

  get 'users/login'
  get 'users/profile' => 'users#profile', :as => :profile
  get 'users/dashboard' => 'users#dashboard', :as => :dashboard
  get 'users/calendar'  => 'users#calendar', :as => :calendar
  get 'users/jobs' => 'users#jobs', :as => :jobs

  get 'users/post' => 'users#post', :as => :post
  resources :users

=======
  devise_for :users
  resources :profile

  root to: "home#index"
>>>>>>> a82aaa1014d7ac52070014bbd5c2fd5c8abb7b2f
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
<<<<<<< HEAD
  root 'users#login'
=======
  # root 'welcome#index'
>>>>>>> a82aaa1014d7ac52070014bbd5c2fd5c8abb7b2f

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
