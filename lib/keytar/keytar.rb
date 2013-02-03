require 'redis'

class Redis
	class Keytar

		COMMANDS = {
			"set" : [ :first ]
		}

		attr_accessor :namespace, :redis, :ttl

		def initialize(options={})
			@redis 			= options[:redis] 		|| Redis.current
			@namespace 	= options[:namespace] || ""
			@ttl 				= options[:ttl]
		end

		def keytar_namespace(namespace)
			@namespace = namespace
		end

		def keytar_redis(redis)
			@redis = redis
		end

		def keytar_ttl(ttl)
			@ttl = ttl
		end

		# create list of commands we respond to (see redis namespace)

		def method_missing(command, *args, &block)
			handle = COMMANDS[command.to_s]

			unless handle
				return @redis.send(command, *args, &block)
			end

			# add namespace, set key, set ttl, add 

			case handle
			when nil
			end
		end

		def prepend_namespace
		end

		def delegate_command
		end

		def set_ttl
		end

		def aggregate_keys
		end
	end
end