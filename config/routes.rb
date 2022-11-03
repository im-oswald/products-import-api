# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'api/v1/imports#index'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :imports, only: %i[create index]
    end
  end
end
