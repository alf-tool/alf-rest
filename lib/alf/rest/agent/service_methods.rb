module Alf
  module Rest
    class Agent
      module ServiceMethods

        def assert!(msg = "an assertion failed", &bl)
          if bl
            db_conn.assert!(msg, &bl)
          else
            with_restricted_relvar do |rv|
              rv.not_empty!(msg)
            end
          end
        end

        def deny!(msg = "an assertion failed", &bl)
          if bl
            db_conn.deny!(msg, &bl)
          else
            with_restricted_relvar do |rv|
              rv.empty!(msg)
            end
          end
        end

        def get
          with_restricted_relvar do |rv|
            app.send_payload(mode==:tuple ? rv.tuple_extract : rv)
          end
        end

        def post
          raise NotSupportedError unless mode==:relation
          with_restricted_relvar do |rv|
            single  = Hash===self.body || Tuple===self.body

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

            # sets the location
            set_location(created)

            # yield if requested
            yield(created) if block_given?

            # app.send_payload now
            app.status 201
            201
          end
        end

        def no_post(tuple)
          set_location(tuple)
          app.status 303
          303
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

            # app.send_payload now
            app.status 200
            200
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

      end # module ServiceMethods
    end # class Agent
  end # module Rest
end # module Alf
