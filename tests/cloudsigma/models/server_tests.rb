Shindo.tests('Fog::Compute[:cloudsigma] | server model', ['cloudsigma']) do
  service = Fog::Compute[:cloudsigma]
  servers = Fog::Compute[:cloudsigma].servers
  server_create_args =  {:name => 'fogtest', :cpu => 2000, :mem => 512*1024**2, :vnc_password => 'myrandompass'}

  model_tests(servers, server_create_args, true) do
    tests('attach_dhcp_nic').succeeds do
      @instance.add_public_nic()
      @instance.save

      @instance.reload

      returns('dhcp') { @instance.nics.first.ip_v4_conf.conf }
      succeeds {/^([0-9a-f]{2}[:]){5}([0-9a-f]{2})$/ === @instance.nics.first.mac}
    end

    tests('attach_volume') do
      volume_create_args = {:name => 'fogservermodeltest', :size => 1000**3, :media => :cdrom}
      v = service.volumes.create(volume_create_args)
      volume_uuid = v.uuid

      @instance.mount_volume(v)
      @instance.save
      @instance.reload

      returns(volume_uuid) { @instance.volumes.first.volume }

      @instance.unmount_volume(v)
      @instance.save
      @instance.reload

      succeeds { @instance.volumes.empty? }

      v.delete

    end
  end

end