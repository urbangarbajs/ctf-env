FROM debian:bookworm-slim

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY traffic-loop.sh /usr/local/bin/traffic-loop.sh

RUN chmod +x /usr/local/bin/traffic-loop.sh

CMD ["/usr/local/bin/traffic-loop.sh"]
