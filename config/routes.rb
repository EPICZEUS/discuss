Rails.application.routes.draw do
	namespace :api do
		namespace :v1 do
			get '/login', to: 'users#login'

			resources :users
			resources :rooms do
				resources :messages, controller: "rooms/messages"
			end
		end
	end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
