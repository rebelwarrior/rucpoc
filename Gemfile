source 'https://rubygems.org'
heroku = false 

ruby '2.0.0', :engine => 'jruby', :engine_version => '1.7.11' 
#ruby=jruby-1.7.11

#Procfile for heroku: web: bundle exec rails server puma -p $PORT -e $RACK_ENV
if $0['warble']
  puts "run `bundle update jruby-jars` when new version of jruby"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.3'

platforms :jruby do
  group :development do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 1.3.0'  #'~> 1.3.0.beta2'
  end
  group :production do
    if heroku 
      gem 'activerecord-jdbcpostgresql-adapter', '~> 1.3.0' #'~> 1.3.0.beta2'
    else
      gem 'activerecord-jdbcmssql-adapter', '~> 1.3.2'
    end
  end 
  gem 'activerecord-jdbc-adapter', '~> 1.3.0' #'~> 1.3.0.beta2'
  gem 'therubyrhino'
  gem 'atomic' #For atomic threaded operations
end

# Puma as server
gem 'puma', '~> 2.8.0'

# For CSV importing
gem 'smarter_csv'
gem 'cmess'

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
# gem 'bcrypt-ruby', '~> 3.0.0'
gem 'bcrypt-ruby', '~> 3.1.2'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

gem 'will_paginate', '~> 3.0.4'
gem 'bootstrap-will_paginate'

# Markdown
gem 'kramdown' 

group :development, :test do
  # Cucumber # Remember to move /script/cucumber to /bin/cucumber
    gem 'cucumber', require: false
    gem 'cucumber-rails', '~> 1.4.0', :require => false
  # Rspec  
    gem 'rspec-rails'
    gem 'guard-rspec'
    gem 'factory_girl_rails' 
  # For CoffeeScript Testing.
    # gem 'jasminerice' 
    # gem 'guard-jasmine'
end

group :test do
  #Rspec 
  gem 'faker', '~> 1.2.0'
  gem 'capybara'  #, '~> 2.1.0'
  gem 'database_cleaner'
  gem 'launchy', '~> 2.3.0', require: false
  # gem 'selenium-webdriver', "~> 2.39.0" #causes problems w/ rubyzip
end

group :development do
  gem 'localeapp', require: false
  gem 'pry', require: false
  # Remember to turn pagination off (for Jruby) on .pryrc file: Pry.config.pager = false
  platforms :ruby do
    gem 'sqlite3'
    gem 'github-pages', require: false #Jekyll Integration
  end
end

platforms :ruby do
  group :production do
    gem 'therubyracer'    #javascript
    gem 'pg'              #heroku db
    gem 'unicorn'         # Use unicorn as the app server
    gem 'rails_12factor'  # 12 Factor App for Log Stream 
  end
end

group :deploy do
  platforms :jruby do
    unless heroku
      # For Warbler changes to config/application.rb and config/environtments/production.rb
      gem 'warbler', '1.4.0', :require => false
      # gem 'warbler', '~> 1.4.0.beta1',:git => "https://github.com/jruby/warbler.git", :require => false
      # gem 'net-ssh', :require => "net/ssh"
      # gem 'net-scp', :require => "net/scp" 
      # gem 'torquebox-remote-deployer'
      # gem 'torquebox-rake-support'
      # gem 'torquebox'
    end
  end
end



