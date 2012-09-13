module Alf
  module Rest
    class Agent
      module DatabaseMethods

        def database
          @database ||= begin
            settings = app.settings
            settings.database.connect(settings.adapter)
          end
        end

        def database=(db)
          disconnect
          @database = db
        end

        def with_database
          yield(database)
        end

        def disconnect
          @database.disconnect if @database
        end

      end # module DatabaseMethods
    end # class Agent
  end # module Rest
end # module Alf
