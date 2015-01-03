# Alternative: https://github.com/creationix/nvm
wget --retry-connrefused http://nodejs.org/dist/v0.10.35/node-v0.10.35.tar.gz
tar xzf node-v0.10.35.tar.gz
cd node-v0.10.35
./configure --prefix=/opt/node-0.10.35 && make && make install

. /etc/profile.d/ruby.sh
ruby -pi -e 'sub(/"$/, ":/opt/node-0.10.35/bin\"")' /etc/environment
