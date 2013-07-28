source 'https://rubygems.org'
ruby '1.9.3'
gem 'rails', '3.2.13'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'compass-rails'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-rails'
  gem 'jquery-ui-rails'
end

gem 'bootstrap-sass'
gem 'cancan'
gem 'devise'
gem 'figaro'
gem 'haml-rails'
gem 'rolify'
gem 'simple_form'
gem 'jquery-validation-rails'
gem 'google-tag-manager-rails'
gem 'mandrill-api'
gem 'gibbon'
gem 'opentok'
gem 'friendly_id' # errors with version 5, had to use version 4.09, github: 'FriendlyId/friendly_id', branch: 'master' # Note: You MUST use 5.0.0 or greater for Rails 4.0+
gem 'aws-sdk'
gem 'paperclip'
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :rbx]
  gem 'html2haml'
  gem 'hub', :require=>nil
  gem 'quiet_assets'
end
group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'sqlite3'
end
group :production do
  gem 'pg'
  gem 'dalli'
  gem 'memcachier'
end
group :test do
  gem 'capybara'
  gem 'cucumber-rails', :require=>false
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'launchy'
end
