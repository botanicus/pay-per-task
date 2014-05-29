## Installation

**TODO:** This has to be available on the server, under HTTP Basic Auth.

### Accessing the Server

Add the following lines into your `~/.ssh/config`:

```
Host server
  HostName 178.79.138.233
  User root
  compression yes
```

### Getting the Code

Now you should be able to run `git clone server:/repos/ppt`.

If this command fails, you probably don't have **permissions** to access the server. Run `cat ~/.ssh/id_rsa.pub | pbcopy` and send it to James. **Hint:** it's in your clipboard ;)

### The Rest

* Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](http://www.vagrantup.com).
* Run `vagrant plugin install vagrant-triggers`.
* In the project root run `vagrant up`.
* Add the following lines into `/etc/hosts`:

```
127.0.0.1 pay-per-task.dev
127.0.0.1 api.pay-per-task.dev
127.0.0.1 app.pay-per-task.dev
127.0.0.1 raw.pay-per-task.dev
127.0.0.1 docs.pay-per-task.dev
```

* Now you should be able to go [here](http://docs.pay-per-task.dev) and see this documentation server **running on your machine**. Yay!

**TODO:** Set up Vagrant.

## Development

**TODO:** Write the documentation.

Since the app is **modular**, each module has **its own documentation**:

* [Backend documentation](consumers/README.md).
* [Frontend documentation](webs/README.md).

## Production

### How to Deploy

**Same as on Heroku**, you can just run `push origin master:deployment` and all is going to be taken care of.

Alternatively, you can configure a **convenience shortcut** like so: `git config alias.deploy 'push origin master:deployment'`.

Now just run `git deploy` and time you want to deploy. Easy enough, innit?

**TODO:** Can I install pre-push through Vagrant?

### Advanced Topics

**TODO:** Write the documentation.

* [How it all works?](docs/server.md)
* [Backups](docs/backups.md)
* [Initial server installation](deployment/README.md)
* [Git deployment hooks](hooks/README.md)
