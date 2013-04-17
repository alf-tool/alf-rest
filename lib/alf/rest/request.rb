module Alf
  module Rest
    class Request < Rack::Request

      def initialize(env, heading)
        super(env)
        @heading  = Heading.coerce(heading)
      end
      attr_reader :heading

      def to_relation
        relation = Relation.coerce(each.to_a)
        commons  = heading.to_attr_list & relation.heading.to_attr_list
        relation.project(commons).coerce(heading.project(commons))
      end

      def to_tuple
        to_relation.tuple_extract
      end

    private

      def each(&bl)
        return to_enum unless block_given?
        if form_data?
          yield(Support.symbolize_keys(self.POST))
        else
          Alf::Reader.by_mime_type(media_type, body).each(&bl)
        end
      end

    end # class Request
  end # module Rest
end # module Alf