require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  }, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  scope :enviar_ativos do
    patch ':user_id' => 'enviar_ativos#update'
    get '' => 'enviar_ativos#index'
    post 'schedule' => 'schedule_ativos#schedule'
  end
  #monitorar jobs, seria bom colocar no scopo do authenticated user, caso contrario qualquer usuario poderia acessar
  mount Sidekiq::Web => '/jobs'

end
