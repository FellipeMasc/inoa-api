require 'rufus-scheduler'
require "#{Rails.root}/lib/request"

class Users::RegistrationsController < Devise::RegistrationsController
  
  include RackSessionsFix

  def create 
    super do |resource|
      if resource.persisted?


        interval = params[:user][:intervalo_checagem]
        symbol = params[:user][:ativos]
        preco_compra = params[:user][:preco_compra]
        preco_venda = params[:user][:preco_venda]

        user = resource

        scheduler = Rufus::Scheduler.new

        interval = "#{interval}m"

        scheduler.interval interval do
          resp = Request.api_call(symbol, interval)
          puts resp

          if resp.length() != 0
            NotifierMailer.notify_user(current_user, resp).deliver_now
          end
        end
      end
    end
  end
  
  respond_to :json
  private

  def respond_with(current_user, _opts = {})
    if resource.persisted?
      render json: {
        status: { 
          code: 200, message: 'Cadastrado com sucesso.',
          data: { user: current_user }
        }
      }, status: :ok

      

    else
      render json: {
        status: {message: 'Não foi possível ser cadastrado'}
      }, status: :unprocessable_entity
    end
  end

end
