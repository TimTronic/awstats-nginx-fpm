#!/bin/bash

# copy any existing generated site to the www-root
if [ -f "/cache/index.html" ]; then
    cp -u /cache/index.html /awstats/wwwroot/index.html
fi

# cron to periodically call awstats
/usr/sbin/cron && tail -f /var/log/cron.log &

# fastcgi for nginx instance
/usr/sbin/php-fpm8.2 &
