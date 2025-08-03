# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/:uniq_key', to: 'redirects#show'

  namespace :api do
    namespace :v1 do
      resources :urls, only: %i[] do
        collection do
          post :encode
          get :decode
        end
      end
    end
  end
end
