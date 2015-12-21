require 'active_support/configurable'

module Webhooker
  include ActiveSupport::Configurable
  config_accessor :payload_key

  configure do |c|
    c.payload_key = 'payload'
  end
end
