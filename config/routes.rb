Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: :create do
  	collection do
  		post 'login' 
  		post 'verify_token'
  	end
  end

  resources :requests do
    collection do
      get 'user_requests'
      get 'count'
      post 'map_requests'
    end
  end

  get 'messages/update_read/:id/', to: 'messages#update_read', as: 'update_read'
  get 'messages/unread', to: 'messages#unread', as: 'messages_unread'

  resources :conversations 

  resources :messages, except: [:show]

  get 'conversation/:id/messages', to: 'messages#getConversationMessages', as: 'conversation_messages'
  

  #get '*path', to: "application#fallback_index_html", constraints: ->(request) do
   # !request.xhr? && request.format.html?
  #end

end
