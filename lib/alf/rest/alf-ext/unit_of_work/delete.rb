module Alf
  module Sequel
    module UnitOfWork
      class Delete

        def rack_status
          200
        end

        def rack_body
          {status: "success", message: "deleted"}
        end

        def rack_location(request)
          nil
        end

      end # class Delete
    end # module UnitOfWork
  end # module Sequel
end # module Alf
