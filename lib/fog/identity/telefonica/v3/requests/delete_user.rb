module Fog
  module Identity
    class Telefonica
      class V3
        class Real
          def delete_user(id)
            request(
              :expects => [204],
              :method  => 'DELETE',
              :path    => "users/#{id}"
            )
          end
        end

        class Mock
        end
      end
    end
  end
end
