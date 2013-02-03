# Keytar

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'keytar'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install keytar

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


keytar gem

create redis namespaces to cache key lists and have invalidation methods

ex: 

keytar_redis REDIS
keytar_namespace 'api:articles'
keytar_ttl 30.days

keytar.set id, Article.create

# which will execute: 
	# key = namespace+":"+key
	# REDIS.set key, value
	# REDIS.sadd namespace+":keys", key
	# REDIS.expire key, ttl

# later we can say in the controller

keytar.clear
# which will execute
	# keys = REDIS.smembers namespace+":keys"
	# keys.each do |key|
	#   REDIS.del key
	# end

