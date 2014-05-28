<!-- Copied from Matcher. -->

Vagrant proxies port 80 on the VM to port 8080 on local machine. So you can go to [localhost:8080](http://localhost:8080/) and you'll see Nginx is running. It however needs to know the domains in order to match the correct paths.

## The Manual Way

*I recommend you to use automatic resolving as described bellow, but theoretically you might need to do it manually.*

Add the following entries into your `/etc/hosts`:

```shell
127.0.0.1 matcherapp.dev
127.0.0.1 api.matcherapp.dev
127.0.0.1 m.matcherapp.dev
127.0.0.1 stream.matcherapp.dev
127.0.0.1 wiki.matcherapp.dev
```

Now you should be able to query [http://api.matcherapp.dev:8080/tags](http://api.matcherapp.dev:8080/tags) and get list of tags.

## DNS Powered Automatic Resolving of `.dev`

This is much nicer way. Anything ending with `.dev` goes to `localhost`. Currently we don't **need** this solution. It's better in general because it enables you to use wildcard comains like `botanicus.myblogapp.dev`.

```shell
brew install dnsmasq
```

`/usr/local/etc/dnsmasq.conf`:

```
address=/.dev/127.0.0.1
listen-address=127.0.0.1
```

Now start dnsmasq:

```shell
sudo cp -fv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
```

`/etc/resolver/dev`:

```
nameserver 127.0.0.1
```

Now when you `ping test.dev` you should see it's actually talking to `127.0.0.1`.

## Redirect Port 8080 to Port 80

URLs like http://matcherapp.dev:8080 looks terrible. Fortunatelly the fix is simple:

```shell
sudo /sbin/ipfw add 10000 fwd 127.0.0.1,8080 tcp from any to me 80
```

Now you can just go straight to http://matcherapp.dev.

## Links

* [My Delicious: .dev domain](https://delicious.com/botanicus_x/.dev%20local%20domain)
