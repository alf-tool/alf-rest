require 'spec_helper'
module Alf
  module Rest
    describe ErrorApp do
      include Rack::Test::Methods

      def logger
        @logger ||= Class.new{
          def initialize
            @logged = @gravity = nil
          end
          attr_reader :logged, :gravity
          [ :debug, :info, :warn, :error ].each{|m|
            define_method(m){|msg| @gravity = m; @logged = msg }
          }
        }.new
      end

      def mock_app(environment, cfg, ex)
        cfg.logger = logger
        ex.set_backtrace ["a backtrace"]
        Class.new(ErrorApp) do
          enable :raise_errors
          set :environment, environment
          before{
            env[Rest::RACK_CONFIG_KEY] = cfg
            env[Rest::RACK_ERROR_KEY]  = ex
            env['HTTP_ACCEPT'] = 'text/plain'
          }
        end
      end

      let(:config){ Config.new }

      before do
        get '/'
      end

      let(:app){ mock_app(the_env, config, error) }

      context 'with an ArgumentError' do
        let(:error){ ArgumentError.new("fooo is bad") }

        before do
          last_response.status.should eq(500)
        end

        after do
          logger.logged.should =~ /fooo is bad/
          logger.logged.should =~ /a backtrace/
          logger.gravity.should eq(:error)
        end

        context 'in production' do
          let(:the_env){ :production }
          it 'sets a single message' do
            last_response.body.should =~ /an error occured/
          end
        end

        context 'in staging' do
          let(:the_env){ :staging }
          it 'sets the real message' do
            last_response.body.should =~ /fooo is bad/
          end
        end
      end

      context 'when JSON is unable to parse' do
        let(:error){ begin JSON.parse("{:"); rescue => ex; ex; end }

        before do
          last_response.status.should eq(400)
        end

        context 'in production' do
          let(:the_env){ :production }
          it 'sets a single message' do
            last_response.body.should =~ /invalid json body/
          end
        end

        context 'in staging' do
          let(:the_env){ :staging }
          it 'sets the real message' do
            last_response.body.should =~ /unexpected token at/
          end
        end
      end

    end
  end
end