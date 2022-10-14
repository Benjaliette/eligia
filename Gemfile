source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Use Autoprefixer to parse CSS and add vendor prefixes to CSS rules
gem "autoprefixer-rails"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Acts As State Machine
gem 'aasm'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Helper to add breadcrumbs for rails
gem "breadcrumbs_on_rails"

# Use cloudinary to store pictures and documents on the cloud
gem 'cloudinary'

# Merge pdfs to include user uploaded documents in order_account pdf show
gem 'combine_pdf'

# Used devise to code the users table
gem "devise"

# Factorybot : used to generate fixtures for testing
gem "factory_bot_rails"

# Use font-awesome gem to use icons
gem "font-awesome-sass", "~> 6.1"

# For human-friendly urls
gem 'friendly_id', '~> 5.4.0'

# Geocoder is used to store address in users and allow them to have an autocompletion when entering their address
gem "geocoder"

# GCS is used to store in a secure way all of the datas/documents
gem 'google-cloud-storage', '~> 1.41'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Gem originally in older version of Ruby than 3.1
gem 'matrix'

# Gem used to generate meta tags
gem 'meta-tags'

# Gem to store a money column into DB (here the orders table)
gem 'money-rails'

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Gem to implement model research
gem 'pg_search'

# Use Postmark to take care of mails in production
gem 'postmark-rails'

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Pundit is a restrcited access to admin for deletion of orders and related tables (order_accounts & order_documents) & to validate accounts
gem 'pundit'

# For PDF generation
# gem 'prawn-rails', '~> 1.4.2'
gem 'prawn', '~> 2.4.0'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.3"

# Gem used to have an admin section and check DB
gem 'rails_admin'

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Use Sass to process CSS
gem "sassc-rails"

# Gem simple form is used to builds the forms/nested forms on the website
gem "simple_form", github: "heartcombo/simple_form"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Gem to use Stripe API for paiement
gem 'stripe'

# Allow Stripe to tell us whether the paiement is complete
gem 'stripe_event'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Pour les tests systèmes
gem 'webrick'

## ===== GEMS FOR DEVELOPMENT / TEST ===== ##

group :development, :test do
  gem "dotenv-rails"
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  # Tests are made with Rspec
  gem 'rspec-rails'
end


## ===== GEMS FOR DEVELOPMENT ONLY ===== ##

group :development do
  # Use letter opener to open in development mail we just sent
  gem "letter_opener"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end


# ## ===== GEMS FOR TEST ONLY (commented) ===== ##

group :test do
# #   # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara", "~> 3.37.1"
  gem 'capybara-screenshot'
  gem "selenium-webdriver"
  gem "webdrivers", github: 'jmccure/webdrivers', branch:'fix-m1-downloads'
end
