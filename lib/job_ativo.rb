require "#{Rails.root}/lib/request"

class JobAtivo < ActiveJob::Base
	queue_as :default

	def perform(schedule_info)

		email = schedule_info["email"]
		interval = schedule_info["interval"]
		symbol = schedule_info["symbol"]

		resp = Request.api_call(symbol, interval)
	
		if resp.length() != 0
			NotifierMailer.notify_user(email, resp).deliver_now
		end

	end
end
