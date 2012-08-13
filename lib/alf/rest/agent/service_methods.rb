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

            app.status 201
            serve created
          end
        end

        def delete
          with_restricted_relvar do |rv|
            rv.tuple_extract if mode==:tuple
            rv.delete 
          end
          204
        end

        def patch
          raise NotSupportedError unless mode==:tuple
          with_restricted_relvar do |rv|
            rv.tuple_extract
            rv.update(self.body)
            serve rv.tuple_extract
          end
        end
        alias :put :patch

      private

        def serve(data)
          app.content_type :json
          data.to_json
        end

      end # module ServiceMethods
    end # class Agent
  end # module Rest
end # module Alf