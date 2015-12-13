require 'jquery-rails'
require 'slim-rails'
require 'kaminari'
require 'bootstrap-sass'
require 'font-awesome-sass'

module Webhooker
  class Engine < ::Rails::Engine
    isolate_namespace Webhooker

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
      g.view_specs false
      g.routing_specs false
      g.helper_specs false
      g.request_specs false
      g.integration_tool false
      g.assets false
      g.helper false
    end
  end
end
