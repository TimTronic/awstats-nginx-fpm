#!/bin/bash

set -e

lockfile -r 0 /tmp/awstats.lock || exit 1

echo 'Generating AWStats'

mkdir -p /cache

nice /awstats/wwwroot/cgi-bin/awstats.pl -config=/etc/awstats/awstats.conf.local -update -output > /tmp/awstats-index.html
#nice /usr/share/awstats/tools/awstats_buildstaticpages.pl -config=awstats.conf -update -dir=/cache/awstats-temp
cp /tmp/awstats-index.html /cache/index.html
cp /tmp/awstats-index.html /awstats/wwwroot/index.html

echo 'Finished generating AWStats'
