Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace 'api' do
    namespace 'v1' do
      resources :regexes
      post 'regexes/check', to: 'regexes#check'
      post 'regexes/:id/like', to: 'regexes#like'
      post 'regexes/:id/dislike', to: 'regexes#dislike'
      post 'users', to: 'users#create'
      get 'health_checks', to: 'health_checks#index'
    end
  end
end
