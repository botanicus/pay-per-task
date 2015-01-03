apt-get -y update
apt-get -y upgrade
apt-get -y install linux-headers-$(uname -r) build-essential
apt-get -y install zlib1g-dev
# apt-get -y install libruby ruby-dev libedit-dev

# Rubinius dependencies http://rubini.us/doc/en/getting-started/requirements.
apt-get -y install bison ruby-dev rake libyaml-dev libssl-dev libreadline-dev libncurses5-dev llvm llvm-dev libeditline-dev libedit-dev

apt-get -y install dkms
