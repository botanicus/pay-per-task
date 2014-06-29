#!/bin/sh

# TODO: production: require auth in Redis http://redis.io/commands/auth (aside of iptables)
redis-cli HMSET users.ppt auth_key Wb9CdGTqEr7msEcPBrHPinsxRxJdM \
                          pt.api_key 78525a130a030829876309975267aa6a \
                          email james@101ideas.cz \
                          created_at 2014-06-29T15:13:37+02:00
