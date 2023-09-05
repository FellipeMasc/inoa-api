require "#{Rails.root}/lib/request"

class ScheduleAtivoJob < ApplicationJob
  queue_as :default

  def perform(api_info)
    puts "oi"
    symbol = api_info["symbol"]
    email = api_info["email"]
    interval = api_info["interval"]
    resp = Request.api_call(symbol, interval)
	
    if resp.length() != 0
      NotifierMailer.notify_user(email, resp).deliver_now
    end
  end
end
