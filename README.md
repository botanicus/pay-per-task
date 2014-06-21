## Installation <small>in 3 easy steps</small>

* Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](http://www.vagrantup.com).
* Then **go** to the **project root** in terminal and run `./setup-mac-os-x.sh`.
* And finally **set up** and **boot** the **virtual machine** using `vagrant up`.

*That's it! You're done!*

## Development <small>... in an instant!</small>

### Working with Vagrant <small>without even knowing it's there!</small>

Working with Vagrant is **easy**. Any time you work on the project, you go to the project root and run `vagrant up` and any time you are done with it run `vagrant halt`. It's important, because the whole virtual machine is **in your RAM**, so you want to make sure to turn it off.

If you need to log in to the virtual server to **inspect logs** or **restart services**, use `vagrant ssh`. In case you'd need so, here's more about our [Vagrant environment](/docs/vagrant.md).

### [PPT Documentation App](http://docs.pay-per-task.dev)

<a href="https://raw.githubusercontent.com/botanicus/doxxu/master/docs.ppt.png">
  <img height="120" src="https://raw.githubusercontent.com/botanicus/doxxu/master/docs.ppt.png" style="padding-right: 10px; float: left" />
</a>

Every piece of **development-related documentation** is available through this app. Basically it's an extremely simple AngularJS app which **renders READMEs** and other documentation written **in Markdown**. Those files are **linked together**, so you can click through any documentation in an instant.

Since this **runs locally** any change you make is **immediately viewable**, unlike on GitHub where you have to push first.

<br>

### PPT Modules

*Since the app is **modular**, each module has **its own documentation**:*

#### [Documentation for Webs and Web API](webs/README.md)

Everything web-related is located in `webs/` directory.

#### [Backend Documentation](consumers/README.md)

Everything related to processing data from issue trackers, mailers and payments is located in `consumers/` directory.

## Production

### Accessing the Server

Run `ssh server`. If if fails, you probably don't have **permissions** to access the server. Run `cat ~/.ssh/id_rsa.pub | pbcopy` and send it to James.

**Hint:** It's in your clipboard.

### Deploying to Production

**Same as on Heroku**, you can just run `git deploy` and all is going to be taken care of. If the command fails, mostly likely you don't have the permissions to SSH the server. The solution is described in the section above.

### Advanced Topics

* [How it all works?](docs/server.md)
* [Backups](docs/backups.md)
* [Initial server installation](deployment/README.md)
* [Git deployment hooks](hooks/README.md)
