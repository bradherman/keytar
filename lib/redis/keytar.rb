require 'redis'

class Redis
	class Keytar

		COMMANDS = {
			"set" => :first,
			"del" => :first
		}

		attr_accessor :namespace, :redis, :ttl

		def initialize(options={})
			@redis 			= options[:redis] 		|| Redis.current
			@namespace 	= options[:namespace] || ""
			@ttl 				= options[:ttl]				|| nil
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

		def method_missing(command, *args, &block)
			handle = COMMANDS[command.to_s]

			return @redis.send(command, *args, &block) unless handle

			case handle
			when :first
				args[0] = prepend_namespace(args[0]) if args[0]
			end

			result = 	@redis.send(command, *args, &block)
								@redis.expire(args[0], @ttl) if @ttl
			
			case command.to_s
			when 'set'
				@redis.sadd @namespace+':keys', args[0]
			when 'del'
				@redis.srem @namespace+':keys', args[0]
			end
		end

		def clear
			@redis.smembers(@namespace+':keys').each do |key|
				@redis.del key
			end
		end

		private

		def prepend_namespace(key)
      return key unless key && @namespace

      case key
      when Array
        key.map {|k| add_namespace k}
      when Hash
        Hash[*key.map {|k, v| [ add_namespace(k), v ]}.flatten]
      else
        "#{@namespace}:#{key}"
      end
    end
	end
end