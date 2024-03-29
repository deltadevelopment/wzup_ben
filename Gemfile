source 'https://rubygems.org'
ruby '2.2.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'


# Handles secrets
gem "figaro"

gem 'rails-api'

gem 'bcrypt' # For general encryption
gem 'active_model_serializers', '~> 0.9.2' # For JSON generation

# Use sqlite3 as the database for Active Record
gem 'pg'

# Monitoring
gem "bugsnag"
gem 'newrelic_rpm'

# Heroku specific
gem 'rails_12factor', group: :production
gem 'rails_stdout_logging'

# Database dump/load
gem 'yaml_db'

# AWS SDK
gem 'aws-sdk', '~> 2'

gem 'resque', :require => 'resque/server'

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'json_spec'
  gem 'guard-rspec', :git => 'https://github.com/guard/guard-rspec.git'
  gem 'rb-readline', '~> 0.5.0'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'shoulda-matchers'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-remote'
  gem 'rubocop'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano', :group => :development

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
