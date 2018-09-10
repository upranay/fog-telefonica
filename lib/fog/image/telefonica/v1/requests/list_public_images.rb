module Fog
  module Image
    class Telefonica
      class V1
        class Real
          def list_public_images(options = {})
            request(
              :expects => [200, 204],
              :method  => 'GET',
              :path    => 'images',
              :query   => options
            )
          end
        end

        class Mock
          def list_public_images(_options = {})
            response = Excon::Response.new
            response.status = [200, 204][rand(2)]
            response.body = {
              "images" => [{
                "name"             => Fog::Mock.random_letters(10),
                "size"             => Fog::Mock.random_numbers(8).to_i,
                "disk_format"      => "iso",
                "container_format" => "bare",
                "id"               => Fog::Mock.random_hex(36),
                "checksum"         => Fog::Mock.random_hex(32)
              }]
            }
            response
          end
        end
      end
    end
  end
end
