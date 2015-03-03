Rails.application.routes.draw do
  

  get 'dashboard/index'

  get 'dashboard/show'

  devise_for :users
  # resources :paperedits

 root 'welcome#index'
get '/faqs' => 'welcome#faqs'
  # resources :lines
resources :paperedits do 
  resources :papercuts
  resources :lines
end


  resources :transcripts do
  resources :lines
end

# trying for best in place, inline editing
resources :lines


resources :blog


resources :dashboard



# get '/features' => 'welcome#features'
# get '/about' => 'welcome#about'

 # gets post request form ajax in show.html.erb, once line as been dropped(in drag and drop).
  # post 'save_paper_edit/' => 'paperedits#save_paper_edit'
  # changed to try something out

post 'save_paper_edit/' => 'papercuts#save_paper_edit'

  # clear all method to empty paper cuts in paper edit
 get 'paperedits/:id/clear_all/' => 'papercuts#clear_all'

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
