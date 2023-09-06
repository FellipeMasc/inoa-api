require 'sidekiq'

class ScheduleAtivosController < ApplicationController

	def schedule 

		comando = params["comando"]
		
		if current_user 
			email = current_user.email
			symbol = current_user.ativos
			interval = current_user.intervalo_checagem
		else
			email = params["email"]
			symbol = params["ativos"]
			interval = params["interval"]
			user = User.find_by(email: email)
		end
		
		puts "oi"
		puts email
		api_info = { "email" => email, "interval" => interval, "symbol" => symbol }


		if comando === "start"
			Sidekiq::Cron::Job.create(name: "#{email}", cron: "*/#{interval} * * * *", class: 'ScheduleAtivoJob', args: api_info)
		elsif comando === "pause"
			job = Sidekiq::Cron::Job.find("#{email}")
			if job
				job.disable!
			end
		elsif comando === "restart"
			job = Sidekiq::Cron::Job.find("#{email}")
			if job
				Sidekiq::Cron::Job.find("#{email}").destroy
			end
			Sidekiq::Cron::Job.create(name: "#{email}", cron: "*/#{interval} * * * *", class: 'ScheduleAtivoJob', args: api_info)
		else
			job = Sidekiq::Cron::Job.find("#{email}")
			if job
				job.enable!
			end
		end

	end
end
