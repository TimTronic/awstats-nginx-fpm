FROM nginx:1

RUN echo "deb http://deb.debian.org/debian bookworm contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/debian-security bookworm-security contrib non-free" >> /etc/apt/sources.list

RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    DEBIAN_FRONTEND=noninteractive \
    apt-get update && apt-get dist-upgrade -y && \
    apt-get install cron libgeo-ip-perl libgeo-ipfree-perl php-fpm -y

# 7.9 appears to be much faster at dynamic stuff
ADD --checksum=sha256:615178ed313d34315f15a522db1a5d12ca9c395e3785bb06280abff95d9a0546 https://cytranet.dl.sourceforge.net/project/awstats/AWStats/7.9/awstats-7.9.tar.gz?viasf=1 /
RUN tar xvf awstats-7.9.tar.gz && mv awstats-7.9 awstats && rm awstats-7.9.tar.gz

#ADD --checksum=sha256:4a65867e01bef6a9bdba3e9e411fb2a0e0d87bc4c85ff02e3cbfca001a04d4b8 https://cytranet.dl.sourceforge.net/project/awstats/AWStats/7.8/awstats-7.8.tar.gz?viasf=1 /
#RUN tar xvf awstats-7.8.tar.gz && mv awstats-7.8 awstats && rm awstats-7.8.tar.gz

# setup php fpm fastcgi
COPY php-fpm.conf /etc/php/8.2/fpm/pool.d/www.conf

# setup cron
COPY crontab /etc/cron.d/awstats
# copy in our cron, remove debian default cron for awstats
RUN chmod 0644 /etc/cron.d/awstats && touch /var/log/cron.log && crontab /etc/cron.d/awstats

# start the cron service
#CMD cron && tail -f /var/log/cron.log
COPY 0-awstats-startup.sh /docker-entrypoint.d/
COPY generate-stats.sh /
COPY awstats.nginx.conf /etc/nginx/conf.d/default.conf
