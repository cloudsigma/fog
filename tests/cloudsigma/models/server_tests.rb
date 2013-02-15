Shindo.tests('Fog::Compute[:cloudsigma] | server model', ['cloudsigma']) do
  servers = Fog::Compute[:cloudsigma].servers
  server_create_args =  {:name => 'fogtest', :cpu => 2000, :mem => 512*1024**2, :vnc_password => 'myrandompass'}

  model_tests(servers, server_create_args, true) do
    tests('#attach_dhcp_nic').succeeds do
      @instance.add_public_nic()
      @instance.save

      @instance.reload

      returns('dhcp') { @instance.nics.first.ip_v4_conf.conf }
    end
  end

end