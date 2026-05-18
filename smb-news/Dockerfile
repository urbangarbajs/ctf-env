FROM debian:bookworm-slim

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends samba smbclient ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY smb.conf /etc/samba/smb.conf
COPY start-samba.sh /usr/local/bin/start-samba.sh
COPY shares/ /srv/samba/

RUN chmod +x /usr/local/bin/start-samba.sh \
    && chmod -R a+rX /srv/samba \
    && chmod -R 0777 /srv/samba/dropbox

EXPOSE 139 445

CMD ["/usr/local/bin/start-samba.sh"]
