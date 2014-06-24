# Scalling

This is a great intro into [various server setups](https://www.digitalocean.com/community/tutorials/5-common-server-setups-for-your-web-application).

*PPT runs on one VPS which most likely will be plenty. I'm therefore not overly concerned about scalling, I'm all trying to do is to make it possible to scale if needed.*

That consists of:

- Using software which can be (reasonably easily) clustered.
- Developing the app in such manner that it can go to cloud easily.

# Current Limitations

## File System

Consumer **ppt.inbox.backup** saves everything to the file system. It doesn't matter too much since this is only just-in-case and also I still might decide to use the API to crawl the apps regularly, since now **ppt.webs.in** is the single point of failure.

## Redis (Rather Theoretical)

Redis can be distributed, but since it's in-memory, the price of that is significantly higher.

# Concerns

- Running multiple VPSs in case one of them goes down.
- Sometimes it might be necessary to run in multiple regions.
- How easy is it to add a node?
- Mirroring everything vs. having chunks of data on different servers.
- Is there a single point of failure?
- No IP hardcoding. Use dynamic discovery instead. Something like Bonjour in Mac-land. As the RabbitMQ clustering guide says: "this could be a dynamic DNS service which has a very short TTL configuration, or a plain TCP load balancer, or some sort of mobile IP achieved with pacemaker or similar technologies.". Actually can HAProxy be used for this?
- Logs?

# Scalling Options of Used Software

*By used software I mean software which doesn't hold any data. Scalling things which doesn't hold data is easy as fuck, just chuck in a bloody loadbalancer or whatever and go back to watching porn!*

## Redis

*Interesting learning: Redis doesn't utilise multiple CPUs. One process, one thread. So even if you are performing 10 reads, those are serial. Obviously with writes it's more complicated, since you don't want to write data over willy-nilly or even write and read at the same time.*

- [Redis Cluster Presentation](http://redis.io/presentation/Redis_Cluster.pdf).
- [Redis Cluster Tutorial](http://redis.io/topics/cluster-tutorial) and [Redis Cluster Spec](http://redis.io/topics/cluster-spec).
- [Ruby Redis Cluster client](https://github.com/antirez/redis-rb-cluster) by antirez. It will eventually become port part of redis-rb.
- [Redis Slave Replication](http://redis.io/topics/replication).
- [Redis Partitioning](http://redis.io/topics/partitioning) (most likely the Redis cluster is a better way to go about this).

## RabbitMQ

*Clustering traditionally isn't the strongest feature of RabbitMQ. Redis has pubsub and a decent clustering solutions, BUT the reason we cannot use it is that it lack the concept of queues and so a consumer has to be running. If it's not running, it's not consuming. If a consumer goes down or is being restarted, data are passing by. RabbitMQ has durable queues, so this doesn't happen.*

- [Distributed RabbitMQ](https://www.rabbitmq.com/distributed.html).
- [RabbitMQ Clustering](https://www.rabbitmq.com/clustering.html).
- Alternatives are the [shovel plugin](https://www.rabbitmq.com/shovel.html) and the [federation plugin](https://www.rabbitmq.com/federation.html).

# Deployment

*Currently we're using a custom solution, as Chef Solo is a pain in the arse AND also you have to bootstrap it. Our solution just gets executed over SSH, no need to install Ruby or anything. What's the point of using a tool for bootstrapping a system when I have to bootstrap the damn tool?? I'm currently researching Ansible since it'd be nice if I wouldn't have to do all this work by myself and also our custom solution isn't cloud-ready. On the other hand, it's super simple, it wouldn't be too hard to make it cloud-ready.*

# Development

Vagrant has built-in support for [clustering](http://docs.vagrantup.com/v2/multi-machine/index.html).

# Further Research

- Would it be better to use Riak? Actually looks like the Redis Cluster is really good.

## CloudFoundry

*Note: CF cloud can also be [installed using Vagrant](http://blog.cloudfoundry.org/2013/06/27/installing-cloud-foundry-on-vagrant).*

**TODO:** Do the research BEFORE I spend too much time on Ansible. One caveat, how do I install CF on my machines, is there the bootstrap-before-bootstrap problem again?

- What are the implications of using it?
- Does it make sense for PPT, if we'd grow rapidly, to use it?
- What are the differences between using CF and just using buch of app servers and DB servers?
