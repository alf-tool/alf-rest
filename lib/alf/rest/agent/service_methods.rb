module Alf
  module Rest
    class Agent
      module ServiceMethods

        def get
          with_restricted_relvar do |rv|
            serve(mode==:tuple ? rv.tuple_extract : rv)
          end
        end

        def post
          raise NotSupportedError unless mode==:relation
          with_restricted_relvar do |rv|
            single  = self.body.is_a?(Hash)

            # project tuples and coerce them
            tuples  = Relation(self.body)
            attrs   = rv.heading.to_attr_list & tuples.attribute_list
            tuples  = tuples.project(attrs)
            tuples  = tuples.coerce(rv.heading.project(attrs))

            # insert them
            ids     = rv.insert(tuples)

            # get created tuples
            created = rv.restrict(Predicate.coerce(ids))
            created = created.tuple_extract if single

            # yield if requested
            yield(created) if block_given?

            # sets the location
            set_location(created)

            # serve now
            app.status 201
            serve created
          end
        end

        def delete
          with_restricted_relvar do |rv|
            rv.tuple_extract if mode==:tuple
            rv.delete
            yield if block_given?
          end
          204
        end

        def patch
          raise NotSupportedError unless mode==:tuple
          with_restricted_relvar do |rv|
            rv.tuple_extract

            # project tuple and coerce it
            tuple = Tuple(self.body)
            attrs   = rv.heading.to_attr_list & tuple.keys
            tuple  = tuple.project(attrs)
            tuple  = tuple.coerce(rv.heading.project(attrs))

            # update it
            rv.update(tuple)

            # get updated tuple
            updated = rv.tuple_extract

            # yield if requested
            yield(updated) if block_given?

            # sets the location
            set_location(updated)

            # serve now
            app.status 200
            serve updated
          end
        end
        alias :put :patch

      private

        def set_location(tuple)
          return unless l = locator
          if location = l.call(tuple)
            app.headers("Location" => location)
          end
        end

        def serve(data)
          app.content_type :json
          data.to_json
        end

      end # module ServiceMethods
    end # class Agent
  end # module Rest
end # module Alf