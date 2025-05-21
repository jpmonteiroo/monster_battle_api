Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :monsters do
        collection do
          post :import
        end
      end
      
      resources :battles, only: [:index, :show, :create, :destroy]
    end
  end
end
