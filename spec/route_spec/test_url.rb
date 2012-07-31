require 'spec_helper'
module Alf
  module Rest
    describe RouteSpec, 'url' do

      let(:route){ RouteSpec.new(options) }

      context 'when an url is explicitely specified' do
        let(:options){ {:url => "/:relvar"} }

        specify 'collection url should be /:relvar' do
          route.url(:relation).should eq('/:relvar')
        end

        specify 'tuple url should be /:relvar/:id' do
          route.url(:tuple).should eq('/:relvar/:id')
        end
      end

      context 'when no url but a relvar is known' do
        let(:options){ {:relvar => :suppliers} }

        specify 'collection url should be /suppliers' do
          route.url(:relation).should eq('/suppliers')
        end

        specify 'tuple url should be /suppliers/:id' do
          route.url(:tuple).should eq('/suppliers/:id')
        end
      end

    end
  end
end