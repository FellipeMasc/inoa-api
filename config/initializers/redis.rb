require 'redis'
require 'yaml'

if Rails.env.production?
	$redis = Redis.new(url: ENV["REDIS_URL"])
else
	# redis_config = YAML::load(File.open(Rails.root.join('config/redis.yml'))).symbolize_keys[Rails.env.to_sym]
	# puts redis_config
	$redis = Redis.new(host: "127.0.0.1", port: 6379)
end