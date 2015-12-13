$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "webhooker/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "webhooker"
  s.version     = Webhooker::VERSION
  s.authors     = ["kayhide"]
  s.email       = ["kayhide@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Webhooker."
  s.description = "TODO: Description of Webhooker."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.5"
  s.add_dependency "sass-rails"
  s.add_dependency "jquery-rails"
  s.add_dependency "slim-rails"
  s.add_dependency "kaminari"
  s.add_dependency "bootstrap-sass"
  s.add_dependency "font-awesome-sass"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "pry"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "fuubar"
  s.add_development_dependency "webmock"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "guard-rspec"
end
