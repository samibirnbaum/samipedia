source 'https://rubygems.org'
 
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.2'

group :production do
  # Use pg as the production database for Active Record
  gem 'pg', '~> 0.20'
end

group :development do
  # Use sqlite3 as the development database for Active Record
  gem 'sqlite3'
  gem 'web-console', '~> 2.0'
end

# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

gem 'thor', '0.19.1'

group :development do
  gem 'listen', '~> 3.0.5'
end

gem 'rspec-rails', '~> 3.7', '>= 3.7.2'
gem 'rails-controller-testing'

gem 'bootstrap', '~> 4.0.0'
gem 'sprockets-rails', '~> 3.2', '>= 3.2.1'

gem 'devise'

gem 'figaro', '1.0'

gem 'shoulda-matchers', '~> 3.1', '>= 3.1.2'

group :development do
  gem "rails-erd"
end

gem "pundit"

gem 'faker', '~> 1.8', '>= 1.8.7'

gem 'stripe'

gem 'redcarpet', '~> 3.4'

gem 'byebug', '~> 9.0', '>= 9.0.6'
