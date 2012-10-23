module Alf
  module Rest
    class Agent
      module AssertionMethods

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

      end # module AssertionMethods
    end # class Agent
  end # module Rest
end # module Alf
