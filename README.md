## Installation <small>in 3 easy steps</small>

* Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](http://www.vagrantup.com/downloads.html).
* Then **go** to the **project root** in terminal and run `./deployment/setup-mac-os-x.sh`.
* And finally **set up** and **boot** the **virtual machine** using `vagrant up`.

*That's it! You're done!*

## Development <small>... in an instant!</small>

### Working with Vagrant <small>without even knowing it's there!</small>

Working with Vagrant is **easy**. Any time you work on the project, you go to the project root and run `vagrant up` and any time you are done with it run `vagrant halt`. It's important, because the whole virtual machine is **in your RAM**, so you want to make sure to turn it off.

If you need to log in to the virtual server to **inspect logs** or **restart services**, use `vagrant ssh`. In case you'd need so, here's more about our [Vagrant environment](/docs/vagrant.md).

### [PPT Documentation](http://docs.pay-per-task.dev)

<a href="https://raw.githubusercontent.com/botanicus/doxxu/master/docs.ppt.png">
  <img height="120" src="https://raw.githubusercontent.com/botanicus/doxxu/master/docs.ppt.png" style="padding-right: 10px; float: left" />
</a>

Every piece of **development-related documentation** is available on **your localhost** on [docs.pay-per-task.dev](http://docs.pay-per-task.dev). Unlike on GitHub, you can view any change you make to documentation instantaneously, you don't have to commit the changes and push them there first.

Now your environment should be all set, so off you go, try it!

How does it work? It simply **renders READMEs** and other documentation written **in Markdown**. Those files are **linked together**, so you can click through any documentation in an instant.

### Developing PPT

First things first, please do install [EditorConfig](http://editorconfig.org/) plugin for your editor. This is not an arbitrary requirement, it's to preserve sanity in cases like working with Git when trailing whitespace makes a big mess.

Have you got it? Alright, moving on ...

#### [Documentation for Webs and APIs](webs/README.md)

Everything web-related is located in `webs/` directory.

#### [Backend Documentation](gems/README.md)

Everything related to processing data from issue trackers, mailers and payments is located in `gems/` directory.

## Production

### Accessing the Server

Run `ssh server`. If if fails, you probably don't have **permissions** to access the server. Run `cat ~/.ssh/id_rsa.pub | pbcopy` and send it to James.

**Hint:** It's in your clipboard.

### Deploying to Production

**Same as on Heroku**, you can just run `git deploy` and all is going to be taken care of. If the command fails, mostly likely you don't have the permissions to connect to SSH on the server. The solution is described in the section above.

### Advanced Topics

* [How it all works?](docs/server.md)
* [Backups](docs/backups.md)
* [Server Deployment](deployment/README.md)
