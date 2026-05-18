FROM debian:bookworm-slim

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends snmpd snmp python3 ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY snmpd.conf /etc/snmp/snmpd.conf
COPY probe_server.py /opt/novapress/probe_server.py
COPY start-monitor.sh /usr/local/bin/start-monitor.sh

RUN chmod +x /usr/local/bin/start-monitor.sh

ENV MIBS=

EXPOSE 161/udp 8081

CMD ["/usr/local/bin/start-monitor.sh"]
