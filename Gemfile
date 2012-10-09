source 'http://rubygems.org'

group :runtime do
  gem "alf", :git => "git://github.com/alf-tool/alf"
  #gem "alf", :path => "../alf"
  gem "sinatra", "~> 1.3", ">= 1.3.2"
end

group :development do
  gem "rake", "~> 0.9.2"
  gem "rspec", "~> 2.10"
  gem "letters"
end

group :test do
  gem "cucumber",  "~> 1.2"
  #gem "rack-test", "~> 0.6.1"
  gem "rack-test",  :git => "git://github.com/brynary/rack-test.git"
  gem "alf-sequel", :git => "git://github.com/alf-tool/alf-sequel"
  #gem "alf-sequel", :path => "../alf-sequel"
  gem "sqlite3", "~> 1.3",      :platforms => ['mri', 'rbx']
  gem "jdbc-sqlite3", "~> 3.7", :platforms => ['jruby']
end
