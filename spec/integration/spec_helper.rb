$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)
require 'alf-sequel'
require 'sinatra/alf-rest'
require 'rspec'
require 'path'
require 'rack/test'

module Helpers

  def mock_app(&bl)
    Class.new(Sinatra::Base){
      register Sinatra::AlfRest
      alf_rest do |cfg|
        cfg.database = Alf.database(Path.backfind('fixtures/sap.db'))
      end
      enable  :raise_errors
      disable :show_exceptions
      instance_eval(&bl)
    }
  end

end

RSpec.configure do |c|
  c.include Helpers
  c.extend  Helpers
end
