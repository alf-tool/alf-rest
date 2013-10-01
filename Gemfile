source 'http://rubygems.org'

group :runtime do
  gem "alf-core", "~> 0.14.0"
  gem "sinatra", "~> 1.3", ">= 1.3.2"
  gem "rack-accept", "~> 0.4.5"
end

group :development do
  gem "rake",  "~> 10.0"
  gem "rspec", "~> 2.12"
end

group :test do
  gem "cucumber",  "~> 1.2"
  #gem "rack-test", "~> 0.6.1"
  gem "rack-test",  :git => "git://github.com/brynary/rack-test.git"
  gem "alf-sequel", "~> 0.14.0"
  gem "sqlite3", "~> 1.3",      :platforms => ['mri', 'rbx']
  gem "jdbc-sqlite3", "~> 3.7", :platforms => ['jruby']
end
