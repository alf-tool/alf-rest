require 'spec_helper'
module Alf
  module Rest
    describe Middleware, 'its Rack behavior' do
      include Rack::Test::Methods

      def mock_app(&bl)
        Class.new(Sinatra::Base) do
          set :environment, :test

          disable :dump_errors
          disable :logging
          disable :dump_errors
          enable :raise_errors
          disable :show_exceptions

          class_config = nil
          use Alf::Rest do |cfg|
            cfg.database = Alf::Database.new(Path.dir)
            class_config  = cfg
            bl.call(cfg) if bl
          end

          get '/check-config' do
            check  = env[Rest::RACK_CONFIG_KEY].is_a?(Config)
            check &= env[Rest::RACK_CONFIG_KEY] != class_config
            check.to_s
          end

          get '/generate-error' do
            raise "blah"
          end
        end
      end

      context 'on a default app' do
        let(:app){ mock_app }

        it 'sets a duplicata of the configuration' do
          get '/check-config'
          last_response.body.should eq("true")
        end
      end

      context 'when an error occurs' do
        let(:app){ mock_app }

        it 'raises the Error outside the app' do
          lambda{ get '/generate-error' }.should raise_error(/blah/)
        end
      end

    end
  end
end
