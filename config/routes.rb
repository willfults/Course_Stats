FirstApp::Application.routes.draw do
  resources :avatars

  devise_for :users, :controllers => { :registrations => "registrations" }
  #authenticate(:user) do
  #  mount MongodbLogger::Server.new, :at => "/mongodb"
  #end
  resque_constraint = lambda do |request|
    request.env['warden'].authenticate? and request.env['warden'].user.admin?
  end

  constraints resque_constraint do
    mount MongodbLogger::Server.new, :at => "/mongodb"
  end

  
  resources :users do
    member do
      get :following, :followers
      get :crop
    end
  end
  
  resources :conversations, only: [:index, :show, :new, :create] do
    member do
      post :reply
      post :trash
      post :untrash
    end
  end
  
  resources :courses do
    get :autocomplete_tag_name, :on => :collection
    resources :course_modules    
  end
  
  match "/images/uploads/*path" => "gridfs#serve"
  resources :avatars

  get "courses/index"
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

  root to: 'static_pages#home'
  match '/help', to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
  match '/signup',  to: 'users#new'
  match '/auth/:service/callback' => 'services#create' 
  resources :services, :only => [:index, :create, :destroy]  
  
  match 'statistics/detail/:id/:class_id' => 'statistics#show', :as => 'statistic'
  match 'statistics/:id' => 'statistics#index'
  mount Resque::Server, :at => "/resque"
  match 'course_landing' => 'courses#course_landing', :as => 'course_landing'
  match 'courses' => 'courses#index'

  match 'my_courses' => 'courses#my_courses'
  match 'manage/courses' => 'courses#manage'

  match 'courses/:id/video' => 'courses#video'
  match 'courses/:course_id/course_modules/:id/quiz/' => 'course_modules#quiz_answers'
  match 'courses/:course_id/course_modules/:id/:status/' => 'course_modules#update_stat'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
