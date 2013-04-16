module Alf
  module Sequel
    module UnitOfWork
      class Update

        def rack_status
          200
        end

        def rack_body
          {status: "success", message: "updated"}
        end

        def rack_location(request)
          ids = pk_matching_relation.tuple_extract.to_hash.values
          "#{request.path}/#{ids.join(',')}"
        end

      end # class Insert
    end # module UnitOfWork
  end # module Sequel
end # module Alf
