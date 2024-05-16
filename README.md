This is a half baked container for generating and displaying awstats.

docker compose should look something like this:

```
services:
  awstats:
    build: ./awstats
    restart: unless-stopped
    networks:
      - traefik
    labels:
      - "traefik.enable=true"
      - "traefik.docker.network=traefik"
      - "traefik.http.services.awstats.loadbalancer.server.port=80"
      - "traefik.http.routers.awstats.entrypoints=https"
      - "traefik.http.routers.awstats.rule=Host(`${URL}`) && PathPrefix(`/awstats/`)"
      - "traefik.http.routers.awstats.tls.certresolver=lets-encr"
    environment:
      - TZ=Americas/Los_Angeles
    volumes:
      - ./awstats.conf:/etc/awstats/awstats.conf:ro
      - <path-to-logs>:/logs:ro
      - awstats_cache:/cache
```