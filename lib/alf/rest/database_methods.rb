module Alf
  module Rest
    module DatabaseMethods

      def adapter
        settings.adapter
      end

      def with_connection(&bl)
        Alf.connect(adapter, &bl)
      end

      def restrict_relvar(rv, id)
        unless key = rv.keys.first
          raise MappingError, "No keys found on `#{Tools.to_lispy(rv.expr)}`"
        end
        if key.size > 1
          id = id.split(',')
          raise KeyMismatch unless id.size == key.size
        end
        heading   = rv.heading
        predicate = Predicate.tautology
        key.to_a.zip(Array(id)).each do |(k,v)|
          v = Alf::Tools.coerce(v, heading[k])
          predicate &= Predicate.eq(k, v)
        end
        rv.restrict(predicate)
      end

      def predicate_for(rel)
        case rel
        when Hash     then rel.inject(Predicate.tautology){|p,(k,v)| p & Predicate.eq(k,v) }
        when Relation then rel.inject(Predicate.contradiction){|p,t| p | predicate_for(t)}
        else
          raise ArgumentError, "Unable to build a predicate for `#{rel}`"
        end
      end

      def with_relvar(name, idr = nil)
        with_connection do |conn|
          rv = conn.relvar(name.to_sym)
          rv = restrict_relvar(rv, idr) if idr
          yield(rv)
        end
      end

      def with_heading(relvar)
        with_relvar(relvar){|rv| yield(rv.heading) }
      end

    end # module DatabaseMethods
  end # module Helpers
end # module PointGuard
