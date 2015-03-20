Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  #namespace :api do  
  #  namespace :v1 do
  #

      # Feed Routes
      get 'feed' => 'feed#list' 

      # Session Routes

      post 'login' => 'sessions#create'
      delete 'login' => 'sessions#destroy'

      # User

      get 'user/:id' => 'users#show'

      post 'register' => 'users#create'

      put 'user/:id' => 'users#update'

      delete 'user/:id' => 'users#destroy' 

      # Following routes

      get 'user/:id/followers' => 'followings#get_followers'
      get 'user/:id/followees' => 'followings#get_followees'

      post 'user/:id/follow/:followee_id' => 'followings#create_or_request'      

      delete 'user/:id/follow/:followee_id' => 'followings#destroy'      

      post 'user/:id/accept_following/:follower_id' => 'followings#accept_following'

      get 'user/:id/follower_requests' => 'followings#get_follower_requests'
      get 'user/:id/followee_requests' => 'followings#get_followee_requests'

      # Subscriber Routes
      
      get 'user/:id/get_subscribees' => 'subscriptions#get_subscribees'

      post 'user/:id/subscribe/:subscribee_id' => 'subscriptions#create'      

      delete 'user/:id/subscribe/:subscribee_id' => 'subscriptions#destroy'      

      # Status routes
      
      get 'user/:user_id/status' => 'statuses#show'
      
      put 'user/:user_id/status' => 'statuses#update'

      get 'status/generate_upload_url' => 'statuses#generate_upload_url'

      # Status media routes
     
      post 'user/:user_id/status/add_media' => 'statuses#add_media'
      
      # Event routes
      
      get 'wave/:id' => 'waves#show'

      post 'wave' => 'waves#create'

      put 'wave/:id' => 'waves#update'  

      delete 'wave/:id' => 'waves#destroy'  

      # Event Invitation routes

      get 'event/:event_id/invitations' => 'invitations#list'

      post 'event/:event_id/invite/:invitee_id' => 'invitations#create'

      get 'invitation/:id' => 'invitations#show'

      put 'event/:event_id/invite/:invitee_id' => 'invitations#update'

      delete 'invitation/:id' => 'invitations#destroy'

      get 'jobs' => 'jobs#list'

      mount Resque::Server, :at => "/resque" 

  #  end
  #end


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
