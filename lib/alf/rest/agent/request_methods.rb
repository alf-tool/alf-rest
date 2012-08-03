module Alf
  module Rest
    class Agent
      module RequestMethods

        # :tuple or :relation mode?
        attr_accessor :mode

        def relvar=(rv)
          @relvar = rv.is_a?(Alf::Relvar) ? rv : db.relvar(rv)
        end
        attr_reader :relvar

        def with_relvar
          yield(relvar)
        end

        def with_restricted_relvar
          with_relvar do |rv|
            yield rv.restrict(restriction)
          end
        end

        def restriction
          @restriction ||= Predicate.tautology
        end
        attr_writer :restriction

        [ :eq, :neq, :gt, :gte, :lt, :lte, :in, :comp ].each do |m|
          define_method(m) do |*args|
            self.restriction &= Alf::Predicate.send(m, *args)
          end
        end

        def primary_key_equal(id)
          with_relvar do |rv|
            unless key = rv.keys.first
              raise MappingError, "No keys found on `#{Tools.to_lispy(rv.expr)}`"
            end
            if key.size > 1
              id = id.split(',')
              raise KeyMismatch unless id.size == key.size
            end
            heading = rv.heading
            predicate = Predicate.tautology
            key.to_a.zip(Array(id)).each do |(k,v)|
              v = Alf::Tools.coerce(v, heading[k])
              predicate &= Predicate.eq(k, v)
            end
            self.restriction &= predicate
          end
        end

      end # module ServiceMethods
    end # class Agent
  end # module Rest
end # module Alf