# Scalling

*PPT runs on one VPS which most likely will be plenty. I'm therefore not overly concerned about scalling, I'm all trying to do is to make it possible to scale if needed.*

That consists of:

- Using software which can be (reasonably easily) clustered.
- Developing the app in such manner that it can go to cloud easily.

# Current Limitations

Consumer **ppt.inbox.backup** saves everything to the file system. It doesn't matter too much since this is only just-in-case and also I still might decide to use the API to crawl the apps regularly, since now **ppt.webs.in** is the single point of failure.

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

# Deployment

*Currently we're using a custom solution, as Chef Solo is a pain in the arse AND also you have to bootstrap it. Our solution just gets executed over SSH, no need to install Ruby or anything. What's the point of using a tool for bootstrapping a system when I have to bootstrap the damn tool?? I'm currently researching Ansible since it'd be nice if I wouldn't have to do all this work by myself and also our custom solution isn't cloud-ready. On the other hand, it's super simple, it wouldn't be too hard to make it cloud-ready.*

# Development

Vagrant has built-in support for [clustering](http://docs.vagrantup.com/v2/multi-machine/index.html).

# Further Research

- Would it be better to use Riak? Actually looks like the Redis Cluster is really good.

## CloudFoundry

- What are the implications of using it?
- Does it make sense for PPT, if we'd grow rapidly, to use it?
- What are the differences between using CF and just using buch of app servers and DB servers?
