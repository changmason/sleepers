Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  scope '/api', module: 'api' do
    put '/sleeps/:uuid', to: 'sleeps#upsert'
    get '/sleeps', to: 'sleeps#index'

    post 'followings', to: 'followings#create'
    delete 'followings/:id', to: 'followings#destroy'

    get '/friends/:id/sleeps', to: 'friend_sleeps#index'
  end
end
