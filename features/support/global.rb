require 'epath'
$:.unshift Path.backfind('./lib').to_s

require 'rack/test'
require 'json'

require 'alf'
require 'alf-rest'
require 'alf/rest/test'
require 'alf-sequel'

def app
  @app ||= begin
    app = Class.new(Alf::Rest::Base)
    app.set :environment, :test
    app.set :adapter, Path.relative("sap.db")
    app
  end
end

def client
  @client ||= Alf::Rest::Test::Client.new(app)
end
