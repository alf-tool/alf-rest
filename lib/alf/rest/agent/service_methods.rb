module Alf
  module Rest
    class Agent
      module ServiceMethods

        def get
          with_restricted_relvar do |rv|
            app.send_payload(mode==:tuple ? rv.tuple_extract : rv)
          end
        end

        def post
          raise NotSupportedError unless mode==:relation
          with_restricted_relvar do |rv|
            single  = TupleLike === self.body

            # project tuples and coerce them
            tuples  = Relation(self.body)
            heading = rv.heading.project(tuples.to_attr_list)
            tuples  = Relation[heading].coerce(tuples.project(heading.to_attr_list))

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
          app.status 204
          204
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
            tuple   = Tuple(self.body)
            heading = rv.heading.project(tuple.keys)
            tuple   = Tuple[heading].coerce(tuple.project(heading.to_attr_list))

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
