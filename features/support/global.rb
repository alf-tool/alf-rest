require 'path'
$:.unshift Path.backfind('./lib').to_s

require 'rack/test'
require 'json'

require 'alf'
require 'alf-rest'
require 'alf/rest/test'
require 'alf-sequel'

def app
  $app ||= begin
    Class.new(Sinatra::Base){
      set :environment, :test
      set :database, Alf.database(Path.relative("sap.db"))
      use Alf::Rest do |cfg|
        cfg.database = settings.database
        cfg.logger   = nil
      end
      helpers Alf::Rest::Helpers
    }
  end
end
