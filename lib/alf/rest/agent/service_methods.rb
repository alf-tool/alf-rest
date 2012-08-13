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
            tuples  = self.body
            ids     = rv.insert(tuples)
            created = rv.restrict(Predicate.coerce(ids))
            created = created.tuple_extract if tuples.is_a?(Hash)

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