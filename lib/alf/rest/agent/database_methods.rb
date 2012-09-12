module Alf
  module Rest
    class Agent
      module DatabaseMethods

        def db
          app.db
        end

      end # module DatabaseMethods
    end # class Agent
  end # module Rest
end # module Alf