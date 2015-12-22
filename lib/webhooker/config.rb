require 'active_support/configurable'

module Webhooker
  include ActiveSupport::Configurable
  config_accessor :payload_key, :attributes_method

  configure do |c|
    c.payload_key = 'payload'
    c.attributes_method = :as_json
  end
end
