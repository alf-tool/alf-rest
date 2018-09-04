$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require "alf/rest/version"
$version = Alf::Rest::Version.to_s

Gem::Specification.new do |s|
  s.name = "alf-rest"
  s.version = $version
  s.summary = "Put your relational database on the web quickly, simply, safely."
  s.description = "Provides a RESTful interface for relational databases."
  s.homepage = "http://github.com/blambeau/alf"
  s.authors = ["Bernard Lambeau"]
  s.email  = ["blambeau at gmail.com"]
  s.require_paths = ['lib']
  here = File.expand_path(File.dirname(__FILE__))
  s.files = File.readlines(File.join(here, 'Manifest.txt')).
                 inject([]){|files, pattern| files + Dir[File.join(here, pattern.strip)]}.
                 collect{|x| x[(1+here.size)..-1]}


  s.add_development_dependency("rake", "~> 10.0")
  s.add_development_dependency("rspec", "~> 2.12")
  s.add_development_dependency("rack-test", "~> 0.6.1")
  s.add_development_dependency("cucumber", "~> 1.2")
  s.add_development_dependency("alf-sequel", "~> 0.15.0")
  s.add_development_dependency("sqlite3", "~> 1.3")
  s.add_development_dependency("jdbc-sqlite3", "~> 3.7")
  s.add_dependency("sinatra", ">= 1.3")
  s.add_dependency("rack-accept", ">= 0.4.5")
  s.add_dependency("alf-core", "~> 0.17.0")
end
