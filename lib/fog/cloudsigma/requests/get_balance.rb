module Fog
  module Compute
    class CloudSigma
      class Real
        def get_balance
          request(:path => "balance/", :method => 'GET', :expects => 200)
        end
      end

      class Mock
        def get_balance

        end
      end

    end
  end
end
