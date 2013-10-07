source 'https://rubygems.org'
heroku = true
if heroku 
  ruby '2.0.0' 
end

if false
  #ruby=jruby-head
  #Magic JRUBY comment
  # ruby '1.9.3', :engine => 'jruby', :engine_version => '1.7.5.dev'
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

platforms :jruby do
  # Use jdbcpostgresql as the database for Active Record
  group :production do
    gem 'activerecord-jdbcpostgresql-adapter', '~> 1.3.0.beta2'
  end
  group :development do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 1.3.0.beta2'
  end
  gem 'activerecord-jdbc-adapter', '~> 1.3.0.beta2'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyrhino'
  gem 'puma'
end

platforms :ruby do
  group :development do
    gem 'sqlite3'
  end
  group :production do
    gem 'therubyracer'
    gem 'pg'
    if heroku
      gem 'rails_12factor' 
      gem 'unicorn'
      gem 'haml-rails'
    end
  end
end


# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
gem 'bootstrap-sass'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  # gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

gem 'will_paginate', '~> 3.0.4'
gem 'bootstrap-will_paginate'

group :development, :test do
  gem 'cucumber', require: false
  gem 'cucumber-rails', '~> 1.4.0', :require => false
  # Remember to move /script/cucumber to /bin/cucumber
  gem 'database_cleaner' #, github: 'bmabey/database_cleaner' #This won't work w/ warbler. 
  gem 'rspec-rails'
  # gem 'guard-rspec'
  gem 'haml-rails'
  # gem 'jasminerice' # For CoffeeScript Testing.
  # gem 'guard-jasmine'
end

group :test do
  gem 'capybara', '~> 2.1.0'
  gem 'capybara-webkit'
end


group :development do
  gem 'localeapp', require: false
  gem 'pry', require: false
  # gem 'pry-rails'
end

group :deploy do
  platforms :jruby do
    gem 'warbler' #, :git => "git@github.com:jruby/warbler.git", :require => false
    gem 'net-ssh', :require => "net/ssh"
    gem 'net-scp', :require => "net/scp" 
    # gem 'torquebox-remote-deployer'
  end
end