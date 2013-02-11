$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)
require 'alf-rest'
require 'rspec'
require 'path'
require 'rack/test'

module Helpers

  def env_for(*args)
    Rack::MockRequest.env_for(*args)
  end

  def json_post_env(tuples)
    env = env_for("/foo", method: 'POST', input: JSON.dump(tuples))
    env.merge('CONTENT_TYPE' => 'application/json')
  end

  def json_post_request(tuples)
    Rack::Request.new(json_post_env(tuples))
  end

  def json_input_payload(tuples)
    Alf::Rest::Payload::Input.new(json_post_request(tuples))
  end

  def mock_app(&bl)
    Class.new(Sinatra::Base){
      register Alf::Rest
      instance_eval(&bl)
    }
  end

end

RSpec.configure do |c|
  c.include Helpers
  c.extend  Helpers
  c.filter_run_excluding :ruby19 => (RUBY_VERSION < "1.9")
end
