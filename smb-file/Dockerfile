FROM ubuntu:22.04

RUN apt-get update && apt-get install -y samba && rm -rf /var/lib/apt/lists/*

COPY smb.conf /etc/samba/smb.conf
COPY data /srv/samba

# make sure path exists
RUN mkdir -p /var/run/samba

EXPOSE 445

CMD ["/usr/sbin/smbd", "--foreground", "--no-process-group", "-s", "/etc/samba/smb.conf"]
