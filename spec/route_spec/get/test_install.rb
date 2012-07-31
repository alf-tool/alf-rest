require 'spec_helper'
module Alf
  module Rest
    describe RouteSpec::Get, 'install' do

      def get(url, &bl)
        raise unless bl
        @seen = url
      end

      subject{ route.install(self); @seen }

      let(:route){ RouteSpec::Get.new(:relvar => :suppliers, :mode => mode) }

      context 'with a relation mode' do
        let(:mode){ :relation }

        it 'installs a GET route under /suppliers' do
          subject.should eq('/suppliers')
        end
      end

      context 'with a tuple mode' do
        let(:mode){ :tuple }

        it 'installs a GET route under /suppliers/:id' do
          subject.should eq('/suppliers/:id')
        end
      end

    end
  end
end