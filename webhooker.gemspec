$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'webhooker/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'webhooker'
  s.version     = Webhooker::VERSION
  s.authors     = ['kayhide']
  s.email       = ['kayhide@gmail.com']
  s.homepage    = 'https://github.com/kayhide/webhooker'
  s.summary     = 'Webhook engine for Rails applications.'
  s.description = 'Webhook engine for Rails applications implemented as a Rails Engine. Extends rails models and triggers webhooks on creating, updating or destroying.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'rails', '~> 5.0'
  s.add_dependency 'sass-rails'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'slim-rails'
  s.add_dependency 'kaminari'
  s.add_dependency 'bootstrap-sass'
  s.add_dependency 'font-awesome-sass'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rails-controller-testing'
  s.add_development_dependency 'spring'
  s.add_development_dependency 'spring-commands-rspec'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'fuubar'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'guard-rspec'
end
