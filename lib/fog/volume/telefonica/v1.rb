require 'fog/telefonica/core'
require 'fog/volume/telefonica'

module Fog
  module Volume
    class Telefonica
      class V1 < Fog::Volume::Telefonica
        SUPPORTED_VERSIONS = /v1(\.(0-9))*/

        requires :telefonica_auth_url

        recognizes *@@recognizes

        model_path 'fog/volume/telefonica/v1/models'

        model :volume
        collection :volumes

        model :availability_zone
        collection :availability_zones

        model :volume_type
        collection :volume_types

        model :snapshot
        collection :snapshots

        model :transfer
        collection :transfers

        model :backup
        collection :backups

        request_path 'fog/volume/telefonica/v1/requests'

        # Volume
        request :list_volumes
        request :list_volumes_detailed
        request :create_volume
        request :update_volume
        request :get_volume_details
        request :extend_volume
        request :delete_volume

        request :list_zones

        request :list_volume_types
        request :create_volume_type
        request :delete_volume_type
        request :get_volume_type_details

        request :create_snapshot
        request :update_snapshot
        request :list_snapshots
        request :list_snapshots_detailed
        request :get_snapshot_details
        request :delete_snapshot
        request :update_snapshot_metadata
        request :delete_snapshot_metadata

        request :list_transfers
        request :list_transfers_detailed
        request :create_transfer
        request :get_transfer_details
        request :accept_transfer
        request :delete_transfer

        request :list_backups
        request :list_backups_detailed
        request :create_backup
        request :get_backup_details
        request :restore_backup
        request :delete_backup

        request :update_quota
        request :get_quota
        request :get_quota_defaults
        request :get_quota_usage

        request :update_metadata
        request :replace_metadata
        request :delete_metadata

        request :set_tenant
        request :action

        class Mock
          def self.data
            @data ||= Hash.new do |hash, key|
              hash[key] = {
                :users   => {},
                :tenants => {},
                :quota   => {
                  'gigabytes' => 1000,
                  'volumes'   => 10,
                  'snapshots' => 10
                }
              }
            end
          end

          def self.reset
            @data = nil
          end

          def initialize(options = {})
            @telefonica_username = options[:telefonica_username]
            @telefonica_tenant   = options[:telefonica_tenant]
            @telefonica_auth_uri = URI.parse(options[:telefonica_auth_url])

            @auth_token            = Fog::Mock.random_base64(64)
            @auth_token_expiration = (Time.now.utc + 86400).iso8601

            management_url            = URI.parse(options[:telefonica_auth_url])
            management_url.port       = 8776
            management_url.path       = '/v1'
            @telefonica_management_url = management_url.to_s

            @data ||= {:users => {}}
            unless @data[:users].find { |u| u['name'] == options[:telefonica_username] }
              id                = Fog::Mock.random_numbers(6).to_s
              @data[:users][id] = {
                'id'       => id,
                'name'     => options[:telefonica_username],
                'email'    => "#{options[:telefonica_username]}@mock.com",
                'tenantId' => Fog::Mock.random_numbers(6).to_s,
                'enabled'  => true
              }
            end
          end

          def data
            self.class.data[@telefonica_username]
          end

          def reset_data
            self.class.data.delete(@telefonica_username)
          end

          def credentials
            {:provider                 => 'telefonica',
             :telefonica_auth_url       => @telefonica_auth_uri.to_s,
             :telefonica_auth_token     => @auth_token,
             :telefonica_management_url => @telefonica_management_url}
          end
        end

        class Real
          include Fog::Telefonica::Core

          def self.not_found_class
            Fog::Volume::Telefonica::NotFound
          end

          def initialize(options = {})
            initialize_identity options

            @telefonica_service_type  = options[:telefonica_service_type] || ['volume']
            @telefonica_service_name  = options[:telefonica_service_name]
            @telefonica_endpoint_type = options[:telefonica_endpoint_type] || 'adminURL'

            @connection_options = options[:connection_options] || {}

            authenticate
            set_api_path

            @persistent = options[:persistent] || false
            @connection = Fog::Core::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
          end

          def set_api_path
            unless @path.match(SUPPORTED_VERSIONS)
              @path = Fog::Telefonica.get_supported_version_path(SUPPORTED_VERSIONS,
                                                                @telefonica_management_uri,
                                                                @auth_token,
                                                                @connection_options)
            end
          end
        end
      end
    end
  end
end
