require "active_resource/validations"

module ActiveResource
  class Errors < ActiveModel::Errors
    def from_json(json, save_cache = false)
      decoded = ActiveSupport::JSON.decode(json) || {} rescue {}
      from_hash decoded, save_cache
    end

    def from_hash(messages, save_cache = false)
      clear unless save_cache

      messages.each do |(key,errors)|
        Array(errors).each do |error|
          if key == 'base'
            self[:base] << error
          else
            add key, error
          end
        end
      end
    end
  end
end