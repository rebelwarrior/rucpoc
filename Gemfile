source 'https://rubygems.org'
heroku = false
if heroku 
  ruby '2.0.0' 
else
  ruby '2.0.0', :engine => 'jruby', :engine_version => '1.7.9' #ruby=jruby-1.7.8
  # run bundle update jruby-jars when new version of jruby
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

platforms :jruby do
  # Use jdbcpostgresql as the database for Active Record
  group :production do
    if heroku 
      gem 'activerecord-jdbcpostgresql-adapter', '~> 1.3.0.beta2'
    else
      gem 'activerecord-jdbcmysql-adapter', '~> 1.3.0.beta2' 
    end
  end
  group :development do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 1.3.0.beta2'
  end
  gem 'puma', '~> 2.6.0'   # Server
  gem 'activerecord-jdbc-adapter', '~> 1.3.0.beta2'
  gem 'therubyrhino'
  gem 'atomic'
end

platforms :ruby do
  group :development do
    gem 'sqlite3'
  end
  group :production do
    if heroku
      gem 'therubyracer', '0.12.0'
      gem 'pg'
      # 12 Factor App for Log Stream
      gem 'rails_12factor' 
      # Use unicorn as the app server
      gem 'unicorn' 
      # Puma as server 
      gem 'puma', '~> 2.6.0'
    end
  end
end

# For CSV importing
gem 'smarter_csv'
gem 'cmess', :git => 'http://github.com/fac/cmess.git'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
gem 'bootstrap-sass', '~> 2.3.2.2'
gem 'haml-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. 
# Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  # gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

gem 'will_paginate', '~> 3.0.4'
gem 'bootstrap-will_paginate'

group :development, :test do
  gem 'cucumber', require: false
  gem 'cucumber-rails', '~> 1.4.0', :require => false
  # Remember to move /script/cucumber to /bin/cucumber
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'factory_girl_rails' 
  # gem 'jasminerice' # For CoffeeScript Testing.
  # gem 'guard-jasmine'
end

group :test do
  gem 'faker', '~> 1.2.0'
  gem 'capybara', '~> 2.1.0'
  # gem 'capybara-webkit', '~> 1.0.0'
  gem 'database_cleaner'
  gem 'launchy', '~> 2.3.0', require: false
end


group :development do
  gem 'localeapp', require: false
  gem 'pry', require: false
  # Remember to turn pagination off on .pryrc file: Pry.config.pager = false
  # gem 'pry-rails'
end

group :deploy do
  platforms :jruby do
    unless heroku
      gem 'warbler', '~> 1.4.0', :require => false
      # gem 'warbler', '~> 1.4.0.beta1',:git => "https://github.com/jruby/warbler.git", :require => false
      # gem 'net-ssh', :require => "net/ssh"
      # gem 'net-scp', :require => "net/scp" 
      # gem 'torquebox-remote-deployer'
      # gem 'torquebox-rake-support'
      # gem 'torquebox'
    end
  end
end

# For Warbler changes to config/application.rb and config/environtments/production.rb
