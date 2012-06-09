ActionController::Routing::Routes.draw do |map|
  
  ##########
  # Frontend routes
  ##########
    
  # Home router
  map.root :controller => "frontend/index" 
  
  # Auth routes
  map.with_options :controller => 'frontend/sessions' do |sessions|
    sessions.logout '/logout.:format', :action => 'destroy'
    sessions.login '/login.:format', :action => 'new'
    sessions.resource :session  
  end 
  
  # User routes
  map.with_options :controller => 'frontend/users' do |users|
    users.register '/register.:format', :action => 'create'
    users.signup '/signup.:format', :action => 'new'
    users.resources :users
  end
  
  # Paginate router    
  map.with_options :requirements => { :id => /\d+/, :page => /\d+/, :format => /html/ } do |route|
    map.category_paginate '/categories/:id/page/:page.:format', :controller => 'frontend/categories', :action => 'show'
    map.tag_paginate '/tag/:id/page/:page.:format', :controller => 'frontend/tags', :action => 'show'
  end  
  
  map.with_options :requirements => { :page => /\d+/, :format => /html/ } do |route|
    route.favorites_paginate '/profile/favorites/page/:page.:format', :controller => 'frontend/favorites', :action => 'index'
    route.requests_paginate '/profile/requests/page/:page.:format', :controller => 'frontend/requests', :action => 'index'
  end
  
  map.with_options :requirements => { :org_id => /\d+/, :page => /\d+/, :format => /html/ } do |route|    
    route.phone_paginate '/orgs/:org_id/phones/page/:page.:format', :controller => 'frontend/phones', :action => 'index'
    route.rewiew_paginate '/orgs/:org_id/rewiews/page/:page.:format', :controller => 'frontend/rewiews', :action => 'index'
    route.associations_paginate '/orgs/:org_id/tags/page/:page.:format', :controller => 'frontend/tags', :action => 'index'
  end  
  
  # Profile routes
  map.resources :profile, :controller => 'frontend/profile', :collection => {:settings => :get}, :only => [:index, :settings]
  map.resources :requests, :controller => 'frontend/requests', :path_prefix => "/profile", :only => :index
  
  # Search routes
  map.resources :search, :controller => 'frontend/search', :only => [:index]
  map.search_auto_complete '/search/auto_complete.:format', :controller => 'frontend/search', :action => 'auto_complete_for_tag_name'
  
  map.profile_favorites '/profile/favorites.:format', :controller => 'frontend/favorites', :action => 'index'  
  
  # Tag router    
  map.tag '/tag/:id.:format', :controller => 'frontend/tags', :action => 'show', :requirements => { :id => /\d+/, :format => /html/}
   
  # Orgs routes  
  map.resources :orgs, :controller => 'frontend/orgs', :member => {:delete => :delete, :update => :put, :destroy => :delete}, :collection => {:create => :post}, :except => :index, :requirements => { :id => /\d+/ }  do |org|
    org.resources :rewiews, :controller => 'frontend/rewiews', :collection => {:create => :post}, :only => [:index, :create], :requirements => { :org_id => /\d+/, :id => /\d+/ } 
    org.resources :phones, :controller => 'frontend/phones', :member => {:delete => :delete}, :collection => {:create => :post}, :only => [:index, :create, :update, :edit, :destroy, :delete, :add_row], :requirements => { :org_id => /\d+/, :id => /\d+/ } 
    org.resources :tags, :controller => 'frontend/tags', :collection => {:create => :post}, :only => [:index, :show, :create, :auto_complete], :requirements => { :org_id => /\d+/, :id => /\d+/ } 
    org.resources :activities, :controller => 'frontend/activities', :member => {:delete => :delete}, :collection => {:create => :post}, :only => [:index, :create, :destroy, :delete], :requirements => { :org_id => /\d+/, :id => /\d+/ } 
    org.resources :favorites, :controller => 'frontend/favorites', :only => [:index, :create, :destroy], :requirements => { :org_id => /\d+/, :id => /\d+/ } 
    org.resources :maps, :controller => 'frontend/maps', :collection => {:create => :post}, :only => [:index, :create], :requirements => { :org_id => /\d+/}
    org.resources :images, :controller => 'frontend/images', :collection => {:create => :post},  :only => [:index, :create], :requirements => { :org_id => /\d+/}  
  end   
  map.add_phone '/phones/add_row.:format', :controller => 'frontend/phones', :action => 'add_row'
  map.resources :categories, :controller => 'frontend/categories', :only => [:show], :requirements => {:id => /\d+/} 
  
  # Service routes
  map.with_options :controller => 'frontend/service' do |route|    
    route.help '/help.:format', :action => 'help'
    route.advertising '/advertising.:format', :action => 'advertising'
    route.contact_us '/contact_us.:format', :action => 'contact_us'
    route.emergency_phones '/emergency_phones.:format', :action => 'emergency_phones'
    route.help_phones '/help_phones.:format', :action => 'help_phones'
    route.terms '/terms.:format', :action => 'terms'
  end
  
  ##########
  # Backend routes
  ##########    
  
  map.admin '/backend.:format', :controller => 'backend/index', :action => 'index'
  
  # Paginate router 
  map.backend_orgs_phones_paginate '/backend/orgs/:org_id/phones/page/:page.:format', :controller => 'backend/phones', :action => 'index', :requirements => { :org_id => /\d+/, :page => /\d+/, :format => /html/ }
   
  map.with_options :requirements => { :page => /\d+/, :format => /html/ } do |route|
    route.backend_towns_paginate '/backend/towns/page/:page.:format', :controller => 'backend/towns', :action => 'index'
    route.backend_streets_paginate '/backend/streets/page/:page.:format', :controller => 'backend/streets', :action => 'index'
    route.backend_roles_paginate '/backend/roles/page/:page.:format', :controller => 'backend/roles', :action => 'index'
    route.backend_tags_paginate '/backend/tags/page/:page.:format', :controller => 'backend/tags', :action => 'index'
    route.backend_associations_paginate '/backend/associations/page/:page.:format', :controller => 'backend/associations', :action => 'index'
    route.backend_search_paginate '/backend/search/page/:page.:format', :controller => 'backend/search', :action => 'index'
    route.backend_users_paginate '/backend/users/page/:page.:format', :controller => 'backend/users', :action => 'index'  
    route.backend_orgs_paginate '/backend/orgs/page/:page.:format', :controller => 'backend/orgs', :action => 'index'
    route.backend_rewiews_paginate '/backend/rewiews/page/:page.:format', :controller => 'backend/rewiews', :action => 'index'
    route.backend_requests_paginate '/backend/requests/page/:page.:format', :controller => 'backend/requests', :action => 'index'
  end
  
  map.with_options :requirements => {:id => /\d+/, :page => /\d+/, :format => /html/ } do |route|
    route.backend_orgs_rewiews_paginate '/backend/orgs/:id/rewiews/page/:page.:format', :controller => 'backend/rewiews', :action => 'show'
    route.backend_orgs_associations_paginate '/backend/orgs/:id/associations/page/:page.:format', :controller => 'backend/associations', :action => 'show'  
    route.backend_town_orgs_paginate '/backend/towns/:id/page/:page.:format', :controller => 'backend/towns', :action => 'show'
    route.backend_street_orgs_paginate '/backend/streets/:id/page/:page.:format', :controller => 'backend/streets', :action => 'show'
    route.backend_category_orgs_paginate '/backend/categories/:id/page/:page.:format', :controller => 'backend/categories', :action => 'show'
    route.backend_users_rewiews_paginate '/backend/users/:id/rewiews/page/:page.:format', :controller => 'backend/users', :action => 'rewiews'
    route.backend_users_orgs_paginate '/backend/users/:id/orgs/page/:page.:format', :controller => 'backend/users', :action => 'orgs'
    route.backend_users_requests_paginate '/backend/users/:id/requests/page/:page.:format', :controller => 'backend/users', :action => 'requests'
    route.backend_users_rights_paginate '/backend/users/:id/rights/page/:page.:format', :controller => 'backend/users', :action => 'rights'
    route.backend_users_associations_paginate '/backend/associations/:id/user/page/:page.:format', :controller => 'backend/associations', :action => 'user'
    route.backend_users_tags_paginate '/backend/tags/:id/user/page/:page.:format', :controller => 'backend/tags', :action => 'user'
  end
  
  # Orgs router
  map.backend_orgs_rewiews '/backend/orgs/:id/rewiews.:format', :controller => 'backend/rewiews', :action => 'show'  
  map.backend_orgs_associations '/backend/orgs/:id/associations.:format', :controller => 'backend/associations', :action => 'create', :conditions => {:method => :post}
  map.backend_orgs_associations '/backend/orgs/:id/associations.:format', :controller => 'backend/associations', :action => 'show'
  map.backend_orgs_requests '/backend/orgs/:id/requests.:format', :controller => 'backend/requests', :action => 'show'
  map.backend_orgs_images '/backend/orgs/:id/images.:format', :controller => 'backend/images', :action => 'show'
    
  map.namespace(:backend) do |backend|
    backend.resources :search, :controller => 'search', :only => [:index]
    backend.resources :towns, :controller => 'towns', :except => :new, :requirements => { :id => /\d+/ }
    backend.resources :streets, :controller => 'streets', :except => :new, :requirements => { :id => /\d+/ }
    backend.resources :roles, :controller => 'roles', :only => [:index, :show, :create, :update, :edit, :destroy], :requirements => { :id => /\d+/ }
    backend.resources :tags, :controller => 'tags', :member => {:user => :get}, :only => [:index, :create, :update, :edit, :destroy, :show, :get], :requirements => { :id => /\d+/ }
    backend.resources :categories, :controller => 'categories', :member => {:restructure => :post}, :only => [:index, :create, :update, :edit, :destroy, :show, :restructure], :requirements => { :id => /\d+/ }
    backend.resources :favorites, :controller => 'favorites', :only => :index
    backend.resources :associations, :controller => 'associations', :member => {:tag => :get, :user => :get}, :only => [:index, :create, :show, :tag, :user, :destroy], :requirements => { :id => /\d+/ }
    backend.resources :orgs, :controller => 'orgs',:member => {:delete_image => :delete}, :except => :edit, :requirements => { :id => /\d+/ }  do |org|
      org.resources :phones, :controller => 'phones', :only => [:index, :create, :update, :edit, :destroy, :add_row]
      org.resources :activities, :controller => 'activities', :only => [:index, :create, :destroy]
      org.resources :maps, :controller => 'maps', :only => [:index, :create, :update, :destroy]
    end
    backend.resources :users, :controller => 'users', :member => {:orgs => :get, :rewiews => :get, :requests => :get, :rights => :get, :add_right => :post}, :only => [:index, :show, :update, :orgs, :rewiews, :requests, :rights, :add_right], :requirements => { :id => /\d+/ }
    backend.resources :rewiews, :controller => 'rewiews', :only => [:index, :show, :edit, :update, :destroy]
    backend.resources :requests, :controller => 'requests', :only => [:index, :show, :edit, :update, :destroy]
    backend.resources :settings, :controller => 'settings', :only => :index
    backend.resources :images, :controller => 'images'
  end
  map.update_backend_settings '/backend/settings/update.:format', :controller => 'backend/settings', :action => 'update', :method => :put
  map.delete_right_backend_user '/backend/users/:id/delete_right/:right_id.:format', :controller => 'backend/users', :action => 'delete_right', :method => :delete
  
  map.backend_add_phone '/backend/phones/add_row.:format', :controller => 'backend/phones', :action => 'add_row'
   
  ##########
  # Default routes
  ##########
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end