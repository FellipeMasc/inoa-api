require "#{Rails.root}/lib/request" 
require 'rufus-scheduler'


class EnviarAtivosController < ApplicationController
	before_action :authenticate_user!

	def index 
		
		data_series = Request.api_data_series(current_user.ativos,current_user.intervalo_checagem)

		ativos = JSON.parse(current_user.ativos)

		render json: {ativos: ativos, intervalo_checagem: current_user.intervalo_checagem, data_series: data_series }
	end

	def update
		puts params


	end

end