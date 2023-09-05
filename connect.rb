require 'redis'
redis = Redis.new(host: "127.0.0.1", port: 6379, db: 0, timeout: 5)
redis.set("mykey", "hello world")
redis.get("mykey")