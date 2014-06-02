Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu-14.04-amd64'
  config.vm.box_url = 'http://static.101ideas.cz/ubuntu-14.04-amd64.box'

  # Log in as root.
  # config.ssh.username = 'root'

  # The hostname the machine should have. Defaults to nil. If nil,
  # Vagrant won't manage the hostname. If set to a string, the hostname
  # will be set on boot.
  #
  # We want this for Oh my ZSH profiles.
  config.vm.hostname = 'ppt.vagrant'

  # Port forwarding.

  # Nginx.
  HTTP_PORT = 8080; HTTPS_PORT = 8081

  config.vm.network :forwarded_port, guest: 80, host: HTTP_PORT
  config.vm.network :forwarded_port, guest: 443, host: HTTPS_PORT

  # 7000: in.pay-per-task.dev
  config.vm.network :forwarded_port, guest: 7000, host: 7000

  # 7001: api.pay-per-task.dev
  config.vm.network :forwarded_port, guest: 7001, host: 7001

  # RabbitMQ & RabbitMQ management plugin.
  config.vm.network :forwarded_port, guest: 5672, host: 5672
  config.vm.network :forwarded_port, guest: 15672, host: 15672

  # http://salvatore.garbesi.com/vagrant-port-forwarding-on-mac/ to get it on port 80.
  # vagrant plugin install vagrant-triggers
  File.open('/tmp/pf.conf', 'w') do |file|
    file.puts <<-EOF
      rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 80 -> 127.0.0.1 port #{HTTP_PORT}
      rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 443 -> 127.0.0.1 port #{HTTPS_PORT}
    EOF
  end

  config.trigger.after [:provision, :up, :reload] do
    system("sudo pfctl -ef /tmp/pf.conf")
    puts '~ Setting up port forwarding.'
  end

  config.trigger.after [:halt, :destroy] do
    system("sudo pfctl -f /etc/pf.conf > /dev/null 2>&1")
    puts '~ Removing port forwarding.'
  end

  # This is required for NFS shared folders (https://coderwall.com/p/uaohzg).
  #
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  #
  # http://docs.vagrantup.com/v2/networking/private_network.html
  # http://en.wikipedia.org/wiki/Private_network#Private_IPv4_address_spaces
  config.vm.network 'private_network', ip: '192.168.33.10'

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
  config.vm.synced_folder 'v-root', '/vagrant', disabled: true
  config.vm.synced_folder '.', '/webs/ppt', nfs: true

  config.vm.synced_folder File.join(ENV['HOME'], '.ssh'), '/host/ssh', nfs: true

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
    'deployment/provisioners/setup-rabbitmq.sh',
    'deployment/provisioners/hosts.sh',
    'deployment/provisioners/vhost.sh',
    'deployment/provisioners/ssh-key.sh',
    'deployment/provisioners/dotfiles.sh'
  ]

  services = Dir.glob('upstart/*.conf').map { |path| path.sub(/^.+\/(.+)\.conf$/, '\1') }
  services.unshift('nginx', 'rabbitmq-server')

  config.vm.provision :shell, privileged: false, inline: <<-EOF
    source /etc/profile.d/ruby.sh
    echo "~ Using Ruby $(ruby -v)"

    cd /etc
    sudo git add --all .
    sudo git commit -m "Before vagrant up." &> /dev/null

    # TODO: Fix this, what the hell?
    sudo restart rabbitmq-server
    sleep 2.5

    cd /webs/ppt
    ./bin/provision.rb #{provisioners.join(' ')}
    echo ""

    sudo git add --all .
    sudo git commit -m "After running provisioners." &> /dev/null

    for file in /webs/ppt/upstart/*.conf; do
      echo "~ Copying $file"
      sudo cp -f $file /etc/init/
      sudo ruby -pi -e 'sub(/^start on .+$/, "start on vagrant-mounted")' /etc/init/$(basename $file)
    done

    cd /etc
    sudo git add --all .
    sudo git commit -m "After vagrant up." &> /dev/null

    source /etc/environment
    source /etc/profile.d/rubinius.sh
    echo "~ Using Rubinius $(ruby -v)"

    cd /webs/ppt/webs/api.pay-per-task.com
    bundle install
    sudo start ppt.webs.api

    cd /webs/ppt/webs/pay-per-task.com
    bundle install

    cd /webs/ppt/webs/pay-per-task.com/subscribe
    bundle install

    echo "\n\n== Environment =="
    echo "PATH=$PATH"
    echo "Ruby: $(ruby -v)"

    echo "\n== Services =="
    for service in #{services.join(" ")}; do
      echo "* $(status $service)"
    done

    echo "\nUse [status|stop|start|restart] [service]."

    echo "\nAll you need to know can be found on http://docs.pay-per-task.dev"
  EOF
end
