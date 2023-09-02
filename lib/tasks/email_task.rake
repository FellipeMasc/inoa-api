require 'request'

namespace :email_task do
	task :test, [:symbol, :interval]  do |t, args|
		Request.api_call(args[:symbol], args[:interval])
	end
end
