## Working with Vagrant

Any time you work on the project, you go to the project root and run `vagrant up` and any time you are done with it run `vagrant halt`. It's important, because the whole virtual machine is **in your RAM**, so you want to make sure to turn it off.

If you need to log in to the virtual server to **inspect logs** or **restart services**, use `vagrant ssh`.

### Managing Services

All our services are defined in `upstart/`. Here is how you work with them:

```
# Assuming you're in Vagrant.
status ppt.webs.api
start ppt.webs.api
restart ppt.webs.api
```

Besides of those, we are using `nginx`, `redis` and `rabbitmq-server`.

### Inspecting Logs

All the logs are located in `/var/log/upstart/<service-name>.log`

vagrant ssh -c 'vagrant ssh -c 'sudo tail -f /var/log/upstart/*.log''
