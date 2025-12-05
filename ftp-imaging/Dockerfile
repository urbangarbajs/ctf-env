FROM ubuntu:22.04

RUN apt-get update && apt-get install -y vsftpd && rm -rf /var/lib/apt/lists/*

COPY vsftpd.conf /etc/vsftpd.conf
COPY banner.txt /etc/banner.txt
COPY data/ /srv/ftp/

RUN chown -R ftp:ftp /srv/ftp

EXPOSE 21

CMD ["/usr/sbin/vsftpd", "/etc/vsftpd.conf"]
