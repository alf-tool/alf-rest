module Alf
  module Rest
    module Helpers
      extend Forwardable
      include Payload::Server

      def alf_config
        env[Rest::RACK_CONFIG_KEY]
      end

      def db_conn
        alf_config.connection
      end

      def with_db_conn
        yield(db_conn)
      end

      def_delegators :db_conn, :relvar,
                               :query,
                               :tuple_extract

      def to_location(url, ids)
        ids = ids.tuple_extract if ids.respond_to?(:tuple_extract)
        ids = ids.to_hash.values
        "#{url}/#{ids.join(',')}"
      end

      def assert!(msg='an assertion failed', status=nil, &bl)
        db_conn.assert!(msg, &bl)
      rescue FactAssertionError => ex
        ex.http_error_status = status
        raise
      end

      def deny!(msg='an assertion failed', status=nil, &bl)
        db_conn.deny!(msg, &bl)
      rescue FactAssertionError => ex
        ex.http_error_status = status
        raise
      end

      def fact!(msg='an assertion failed', status=nil, &bl)
        db_conn.fact!(msg, &bl)
      rescue FactAssertionError => ex
        ex.http_error_status = status
        raise
      end

      def no_duplicate!(&bl)
        found = relvar(&bl)
        unless found.empty?
          ids = found.project(found.keys.first.to_attr_list)
          headers("Location" => to_location(request.path, ids))
          halt(204)
        end
      end

    end
  end
end
