module ActiveResource
  class VerboseLogSubscriber < ActiveSupport::LogSubscriber
    def request(event)
      result = event.payload[:result]
      info "#{event.payload[:method].to_s.upcase} #{event.payload[:request_uri]}"
      event.payload[:request_arguments].each {|s| debug s }
      info "--> %d %s %d (%.1fms)" % [result.code, result.message, result.body.to_s.length, event.duration]
      debug result.body.to_s
    end

    def logger
      ActiveResource::Base.logger
    end
  end
end
