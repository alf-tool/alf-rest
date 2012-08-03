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
            tuples  = JSON.parse(request.body.read) rescue halt(400)
            ids     = rv.insert(tuples)
            created = rv.restrict(Predicate.coerce(ids))
            created = created.tuple_extract if tuples.is_a?(Hash)

            app.status 201
            serve created
          end
        end

        def delete
          with_restricted_relvar do |rv|
            rv.tuple_extract if mode==:tuple # will raise if not existing
            rv.delete 
          end
          204
        end

        def patch
          raise NotSupportedError unless mode==:tuple
          with_restricted_relvar do |rv|
            attrs = JSON.parse(request.body.read) rescue halt(400)
            rv.tuple_extract # to be sure that the tuple exists
            rv.update(attrs)
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