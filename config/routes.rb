Rails.application.routes.draw do

  # constraints(host: 'www.altopedia.org') do
  #   root to: redirect('https://www.altopedia.net'), status: :moved_permanently
  #   get '/:param', to: redirect('https://www.altopedia.net/%{param}'), status: :moved_permanently
  #   get '/activities/:id', to: redirect('https://www.altopedia.net/activities/%{id}'), status: :moved_permanently
  #   get '/tags/:id', to: redirect('https://www.altopedia.net/tags/%{id}'), status: :moved_permanently
  #   get '/textbooks/:id', to: redirect('https://www.altopedia.net/textbooks/%{id}'), status: :moved_permanently
  # end
  
	devise_for :users, controllers: { registrations: "registrations" }
	root 'site_pages#home'

	get '/es', to: 'site_pages#es'
	get '/jhs', to: 'site_pages#jhs'
	get '/hs', to: 'site_pages#hs'
	get '/special_needs', to: 'site_pages#special_needs'
	get '/grammar', to: 'site_pages#grammar'
	get '/warmups', to: 'site_pages#warmups'
	get '/about', to: 'site_pages#about'
  get '/contact', to: 'site_pages#contact'
  get '/resources', to: 'site_pages#resources'
  get '/themes', to: 'site_pages#themes'
	get '/modqueue', to: 'site_pages#modqueue'
  get '/posts/:id', to: 'front_page_posts#show', as: :posts
  get '/shoutbox', to: 'site_pages#shoutbox'
  get '/render_compact_shoutbox', to: 'site_pages#render_compact_shoutbox', as: 'fp_shoutbox'
  get '/contribute', to: 'site_pages#contribute'
  get '/contributors', to: 'site_pages#contributors'
  get '/guide', to: 'site_pages#guide'
  get '/online_teaching', to: 'site_pages#online_teaching'

  get '/search', to: 'tag_searches#new'
  get '/tag_search', to: 'tag_searches#show'
  get '/activity_search', to: 'activity_searches#show'

  resources :tags, :tag_categories, :textbooks, :textbook_pages, :front_page_posts

	resources :users do
		member do
			put :silence
			put :unsilence
			put :promote
			put :demote
      put :trust
      put :untrust
		end
	end
	
	resources :activities do
		member do
			put :approve
			put :unapprove
      put :verify_edits
      put :start_workshop
      put :end_workshop
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
	
end
