# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }


group :development do
  gem 'i18n'
  gem 'fasterer'
  gem 'pry'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'rugged', '~> 0.27.5'
end

group :test do
  gem "rspec", "~> 3.8"
  gem 'simplecov'
  gem 'simplecov-lcov'
  gem 'undercover'
end
