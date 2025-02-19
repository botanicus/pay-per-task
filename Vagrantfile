Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu-15.04-amd64'
  # config.vm.box_url = 'https://www.dropbox.com/s/a88zfgi67s394mh/ubuntu-14.10-amd64.box?dl=1'

  # We want this for Oh my ZSH profiles.
  config.vm.hostname = 'ppt'

  # Port forwarding.
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 443, host: 8081

  # Port forwarding from 8080 back to 80 using vagrant-triggers.
  # http://salvatore.garbesi.com/vagrant-port-forwarding-on-mac
  File.open('/tmp/pf.conf', 'w') do |file|
    file.puts <<-EOF
      rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 80  -> 127.0.0.1 port 8080
      rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 443 -> 127.0.0.1 port 8081
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

  # If true, then any SSH connections made will enable agent forwarding.
  # config.ssh.forward_agent = true
  # config.ssh.insert_key = true

  config.vm.synced_folder 'v-root', '/vagrant', disabled: true
  config.vm.synced_folder '.', '/webs/ppt', nfs: true

  config.vm.synced_folder File.expand_path('~/.ssh'), '/host/ssh', nfs: true

  if ENV['DOTFILES_DIR'] && Dir.exist?(ENV['DOTFILES_DIR'])
    puts "~ Mounting #{ENV['DOTFILES_DIR']} to ~/dotfiles."

    config.vm.synced_folder ENV['DOTFILES_DIR'], '/home/vagrant/dotfiles', nfs: true
  else
    puts "~ WARNING: No dotfiles found! Export DOTFILES_DIR in your shell profile."
  end

  # config.vm.provider 'virtualbox' do |vb|
  #   vb.customize ['modifyvm', :id, '--memory', '1024']
  # end

  #
  # Provisioners.
  #

  config.ssh.shell = 'zsh'

  config.vm.provision :shell, privileged: false,
    path: 'deployment/provisioner.sh',
    args: [
      'deployment/provisioners/iptables.sh',
      'deployment/provisioners/setup-nginx.sh',
      'deployment/provisioners/setup-rabbitmq.sh',
      'deployment/provisioners/hosts.sh',
      'deployment/provisioners/ssh-key.sh',
      'deployment/provisioners/dotfiles.sh',
      'deployment/provisioners/redis-data.sh'
    ]
end
