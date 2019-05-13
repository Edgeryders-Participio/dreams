Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  post "/graphql", to: "graphql#execute"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'camps#index'

  c = Rails.application.config.x.firestarter_settings # TODO ?
  if c['saml_enabled']
    devise_for :users, :skip => [ :registrations ],
               controllers: {
                 omniauth_callbacks: 'users/omniauth_callbacks',
                 registrations: 'users/registrations'
               }
  else
    devise_for :users
  end


  resources :camps, :path => 'dreams' do
    resources :images
    resources :safety_sketches
    get 'get_flag_states', on: :member
    post 'join', on: :member
    post 'archive', on: :member
    post 'create_flag_event', on: :member
    patch 'toggle_favorite', on: :member
    patch 'toggle_approval', on: :member
    patch 'toggle_granting', on: :member
    patch 'update_grants', on: :member
    post 'set_color', on: :member
    post 'remove_tag', on: :member
    post 'tag', on: :member
    patch 'add_member', on: :member
    post 'remove_member', on: :member
  end

  get '/users/:id', to: 'users#show', as: :user
  get '/pages/:page' => 'pages#show'
  get '/howcanihelp' => 'howcanihelp#index'
  get '/guideview' => 'guideview#index'
  
  get '*unmatched_route' => 'application#not_found'
end
