require 'fastly'
require 'uri'

module FastlyRails
  # A simple wrapper around the fastly-ruby client.
  class Client < DelegateClass(Fastly)
    def initialize(opts={})
      super(Fastly.new(opts))
    end

    def purge_by_key(*args)
      unless ENV["FASTLY_CACHE_DISABLED"].present?
        Fastly::Service.new({id: FastlyRails.service_id},     FastlyRails.client).purge_by_key(*args)
      end
    end

    def purge_url(key)
      "/service/#{FastlyRails.service_id}/purge/#{URI.escape(key)}"
    end

    def purge_everything!
      unless ENV["FASTLY_CACHE_DISABLED"].present?
        Fastly::Service.new({id: FastlyRails.service_id},     FastlyRails.client).purge_everything!
      end
    end
  end
end
