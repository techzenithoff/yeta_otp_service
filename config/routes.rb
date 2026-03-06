Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :otps, only: [:create] do
        collection do
          post :verify
        end
      end
    end
  end
end


