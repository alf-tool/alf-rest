module Alf
  module Rest
    class Agent
      module DatabaseMethods

        def db
          @db ||= settings.database.connect(settings.adapter)
        end

        def disconnect
          @db.disconnect if @db
        end

      end # module DatabaseMethods
    end # class Agent
  end # module Rest
end # module Alf