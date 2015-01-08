# About

Shamelessly stolen from [CodeShip](http://blog.codeship.com/packer-vagrant-tutorial/).

# Prerequisites

```
brew install homebrew/binary/packer
```

# Usage

```
./build.sh
```

# Upgrade

Upgrade Ubuntu version AND its [checksum](https://help.ubuntu.com/community/UbuntuHashes) in `packer.json`. Re-run `build.sh`.

# Spec

## Software

- Rubinius (+ Bundler)
- MRI Ruby (+ Bundler)
- Git
- Curl
- ZSH
- Monit
- Nginx
- Node.js
- RabbitMQ

## Setup

- /etc/profile.d/ruby.sh
- /etc/profile.d/rubinius.sh
- Iptables rules.
- Monit rules.
