module Alf
  class Renderer

    def self.supported_media_types
      each.map{|(_,_,r)| r.mime_type}.compact.sort
    end

    def self.from_http_accept(accept)
      media_type = Rack::Accept::MediaType.new(accept)
      if best = media_type.best_of(supported_media_types)
        each.find{|(name,_,r)| r.mime_type == best }.last
      end
    end

  end # class Renderer
end # module Alf
