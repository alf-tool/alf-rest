$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'alf-rest'
require "rspec"
require 'epath'

module Helpers

  def fake_app
  end

end

RSpec.configure do |c|
  c.include Helpers
  c.extend  Helpers
  c.filter_run_excluding :ruby19 => (RUBY_VERSION < "1.9")
end