Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu-14.04-amd64'
  config.vm.box_url = 'http://static.101ideas.cz/ubuntu-14.04-amd64.box'

  # Log in as root.
  config.ssh.username = 'root'

  # Port forwarding.

  # Nginx.
  # => READ http://salvatore.garbesi.com/vagrant-port-forwarding-on-mac/ to get it on port 80.
  config.vm.network :forwarded_port, guest: 80, host: 8080

  # The API.
  config.vm.network :forwarded_port, guest: 4000, host: 4000

  # RabbitMQ & RabbitMQ management plugin.
  config.vm.network :forwarded_port, guest: 5672, host: 8081
  config.vm.network :forwarded_port, guest: 15672, host: 8082

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network 'private_network', ip: '192.168.33.10'

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network 'public_network'

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder '../data', '/vagrant_data'
  config.vm.synced_folder '.', '/webs/ppt'

  config.vm.synced_folder File.join(ENV['HOME'], '.ssh'), '/host/ssh'

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider 'virtualbox' do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ['modifyvm', :id, '--memory', '1024']
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Enable provisioning with CFEngine. CFEngine Community packages are
  # automatically installed. For example, configure the host as a
  # policy server and optionally a policy file to run:
  #
  # config.vm.provision 'cfengine' do |cf|
  #   cf.am_policy_hub = true
  #   # cf.run_file = 'motd.cf'
  # end
  #
  # You can also configure and bootstrap a client to an existing
  # policy server:
  #
  # config.vm.provision 'cfengine' do |cf|
  #   cf.policy_server_address = '10.0.2.15'
  # end


  provisioners = [
    'deployment/shared/rabbitmq.sh',
    'deployment/vagrant/rabbitmq-management.sh',
    'deployment/shared/hosts.sh',
    'deployment/vagrant/ssh-keys.sh',
    'deployment/shared/nginx.sh',
    # 'deployment/shared/logging_pipe.sh',
    'deployment/shared/htpasswd.sh',
    'deployment/vagrant/matcher.sh'
  ]

  config.vm.provision :shell, inline: <<-EOF
    . /etc/environment
    ruby -v
    cd /webs/matcher

    for file in upstart/*.conf; do
      echo "~ Copying $file"
      cp -f $file /etc/init/
    done

    ./bin/provision.rb #{provisioners.join(' ')}
  EOF
end
