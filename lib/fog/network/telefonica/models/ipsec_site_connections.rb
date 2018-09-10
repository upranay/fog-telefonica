require 'fog/telefonica/models/collection'
require 'fog/network/telefonica/models/ipsec_site_connection'

module Fog
  module Network
    class Telefonica
      class IpsecSiteConnections < Fog::Telefonica::Collection
        attribute :filters

        model Fog::Network::Telefonica::IpsecSiteConnection

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters_arg = filters)
          filters = filters_arg
          load_response(service.list_ipsec_site_connections(filters), 'ipsec_site_connections')
        end

        def get(ipsec_site_connection_id)
          connection = service.get_ipsec_site_connection(ipsec_site_connection_id).body['ipsec_site_connection']
          if connection
            new(connection)
          end
        rescue Fog::Network::Telefonica::NotFound
          nil
        end
      end
    end
  end
end
