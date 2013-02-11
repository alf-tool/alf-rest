source 'http://rubygems.org'

group :runtime do
  gem "alf-core", :git => "git://github.com/alf-tool/alf-core"
  #gem "alf-core", :path => "../alf-core"
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
  gem "alf-sequel", :git => "git://github.com/alf-tool/alf-sequel"
  #gem "alf-sequel", :path => "../alf-sequel"
  gem "sqlite3", "~> 1.3",      :platforms => ['mri', 'rbx']
  gem "jdbc-sqlite3", "~> 3.7", :platforms => ['jruby']
end
