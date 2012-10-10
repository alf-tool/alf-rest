module Alf
  module Rest
    class Agent
      module RequestMethods

        # :tuple or :relation mode?
        attr_accessor :mode

        # The relation variable we are going to touch
        def relvar=(rv)
          @relvar = rv.is_a?(Alf::Relvar) ? rv : db_conn.relvar(rv)
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

        # Restriction predicate on relvar
        def restriction
          @restriction ||= Predicate.tautology
        end
        attr_writer :restriction

        [ :eq, :neq, :gt, :gte, :lt, :lte, :in, :comp, :between ].each do |m|
          define_method(m) do |*args|
            self.restriction &= Alf::Predicate.send(m, *args)
          end
        end

        def primary_key_equal(id)
          with_relvar do |rv|
            if (key = first_key!(rv)).size > 1
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

        # The insert/update body for PUT/PATCH/POST
        attr_accessor :body

        # The location generator to use
        def locator=(locator)
          case locator
          when Proc
            @locator = locator
          when String
            @locator = lambda{|tuple|
              if tuple.respond_to?(:to_hash)
                key = with_relvar{|rv| first_key!(rv)}.to_a
                val = key.map{|attr| tuple.to_hash[attr]}.join(",")
                "#{locator}/#{val}"
              end
            }
          when NilClass
            @locator = locator
          end
        end
        attr_reader :locator

      private

        def first_key!(rv)
          unless key = rv.keys.first
            raise MappingError, "No keys found on `#{Tools.to_lispy(rv.expr)}`"
          end
          key
        end

      end # module ServiceMethods
    end # class Agent
  end # module Rest
end # module Alf
