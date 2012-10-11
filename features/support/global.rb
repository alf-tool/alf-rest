require 'path'
$:.unshift Path.backfind('./lib').to_s

require 'rack/test'
require 'json'

require 'alf'
require 'alf-rest'
require 'alf/rest/test'
require 'alf-sequel'

Alf::Rest::Test.config do |cfg|
  cfg.database = Alf.database(Path.relative("sap.db"))
  cfg.logger   = nil
end

def app
  $app ||= begin
    Class.new(Sinatra::Base){
      set :environment, :test
      use Alf::Rest, Alf::Rest::Test.config
      helpers Alf::Rest::Helpers
    }
  end
end
