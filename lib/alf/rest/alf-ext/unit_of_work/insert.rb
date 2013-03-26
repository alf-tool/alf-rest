module Alf
  module Sequel
    module UnitOfWork
      class Insert

        def rack_status
          201
        end

        def rack_body
          {status: "success", message: "created"}
        end

        def rack_location(request)
          ids = matching_relation.tuple_extract.to_hash.values
          "#{request.path}/#{ids.join(',')}"
        end

      end # class Insert
    end # module UnitOfWork
  end # module Sequel
end # module Alf
