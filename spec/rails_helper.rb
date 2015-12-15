require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../dummy/config/environment', __FILE__)
abort("Running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'webmock/rspec'
require 'pry'
require 'factory_girl_rails'

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

FactoryGirl.definition_file_paths << 'spec/dummy/spec/factories'

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before do
    FactoryGirl.reload
  end

  Module.new do
    def self.included base
      base.routes { ::Webhooker::Engine.routes }
    end
    config.include self, type: :controller
  end
end
