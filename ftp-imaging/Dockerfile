FROM ubuntu:22.04

RUN apt-get update && apt-get install -y vsftpd && rm -rf /var/lib/apt/lists/*

COPY vsftpd.conf /etc/vsftpd.conf
COPY banner.txt /etc/banner.txt
COPY data/ /srv/ftp/

RUN mkdir -p /var/run/vsftpd/empty && chmod 755 /var/run/vsftpd/empty
# vsftpd requires non-writable chroot; keep root-owned top dir, ftp-owned contents
RUN chown root:root /srv/ftp && chmod 755 /srv/ftp && chown -R ftp:ftp /srv/ftp/*

EXPOSE 21

CMD ["/usr/sbin/vsftpd", "/etc/vsftpd.conf"]
