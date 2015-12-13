require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../dummy/config/environment', __FILE__)
abort("Running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'pry'
require 'factory_girl_rails'

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
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
