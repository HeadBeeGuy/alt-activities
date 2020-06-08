Rails.application.routes.draw do
  
	devise_for :users, controllers: { registrations: "registrations" }
	root 'site_pages#home'

	get '/es', to: 'site_pages#es'
	get '/jhs', to: 'site_pages#jhs'
	get '/hs', to: 'site_pages#hs'
  get '/conversation', to: 'site_pages#conversation'
	get '/grammar', to: 'site_pages#grammar'
	get '/warmups', to: 'site_pages#warmups'
	get '/about', to: 'site_pages#about'
  get '/contact', to: 'site_pages#contact'
  get '/resources', to: 'site_pages#resources'
  get '/thanks', to: 'site_pages#thanks'
  get '/themes', to: 'site_pages#themes'
	get '/modqueue', to: 'site_pages#modqueue'
	get '/all_tags', to: 'tag_categories#index'
  get '/posts/:id', to: 'front_page_posts#show', as: :posts
  get '/jobs', to: 'job_posts#index'
  get '/shoutbox', to: 'site_pages#shoutbox'
  get '/discord', to: 'site_pages#render_discord'
  get '/render_compact_shoutbox', to: 'site_pages#render_compact_shoutbox', as: 'fp_shoutbox'
  get '/contribute', to: 'site_pages#contribute'
  get '/contributors', to: 'site_pages#contributors'
  get '/guide', to: 'site_pages#guide'

  get '/search', to: 'tag_searches#new'
  get '/tag_search', to: 'tag_searches#show'
  get '/activity_search', to: 'activity_searches#show'

  resources :tags, :tag_categories, :textbooks, :textbook_pages, :front_page_posts, :job_posts

	resources :users do
		member do
			put :silence
			put :unsilence
			put :promote
			put :demote
		end
	end
	
	resources :activities do
		member do
			put :approve
			put :unapprove
			delete :delete_attached_document
		end
	end

  resources :englipedia_activities do
    member do
      put :convert
    end
  end

  resources :upvotes, only: [ :create, :destroy ]
  resources :taggings, only: [ :create, :destroy ]
  resources :activity_links, only: [ :create, :index, :destroy ]
  
  resources :comments do
    member do
      put :approve
      put :unapprove
      put :solve
    end
  end

  get '/activity_links/new/:source_id', to: 'activity_links#new', as: 'new_activity_link'
  get '/activity_links/:source_id/search', to: 'activity_links#link_search', as: 'link_search'
	

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
