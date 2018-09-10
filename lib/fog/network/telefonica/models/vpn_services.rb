require 'fog/telefonica/models/collection'
require 'fog/network/telefonica/models/vpn_service'

module Fog
  module Network
    class Telefonica
      class VpnServices < Fog::Telefonica::Collection
        attribute :filters

        model Fog::Network::Telefonica::VpnService

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters_arg = filters)
          filters = filters_arg
          load_response(service.list_vpn_services(filters), 'vpnservices')
        end

        def get(vpn_service_id)
          if vpn_service = service.get_vpn_service(vpn_service_id).body['vpnservice']
            new(vpn_service)
          end
        rescue Fog::Network::Telefonica::NotFound
          nil
        end
      end
    end
  end
end
