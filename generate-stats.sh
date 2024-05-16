#!/bin/bash

#set -e

exec 3>/tmp/awstats.lock
flock -n 3 || exit 1

echo 'Generating AWStats'

mkdir -p /cache

nice /awstats/wwwroot/cgi-bin/awstats.pl -config=/etc/awstats/awstats.conf.local -update -output > /tmp/awstats-index.html && \
    cp /tmp/awstats-index.html /cache/index.html && \
    cp /tmp/awstats-index.html /awstats/wwwroot/index.html

echo 'Finished generating AWStats'

