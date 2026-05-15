FROM ubuntu:22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3 socat && \
    rm -rf /var/lib/apt/lists/*

COPY start-ftp.py /usr/local/bin/start-ftp.py
COPY public/ /srv/ftp/public/
COPY archive/ /archive/

RUN chmod +x /usr/local/bin/start-ftp.py && \
    mkdir -p /root/drafts && \
    chmod -R 755 /srv/ftp && \
    chmod -R 700 /archive /root/drafts

RUN printf '%s\n' 'NP-CTF{VSFTPD_BACKDOOR_NEWS_ARCHIVE}' > /root/flag_ftp_shell.txt && \
    printf '%s\n\n%s\n' \
      'Osnutek: Notranja preiskava arhiva NovaPress' \
      'Uredništvo preverja nenavadne dostope do starega FTP arhiva. V osnutku je navedeno, da je bila najdena končna laboratorijska oznaka NP-CTF{UNPUBLISHED_DRAFTS_EXFILTRATED}.' \
      > /root/drafts/unpublished-investigation.txt

EXPOSE 21 6200

CMD ["/usr/local/bin/start-ftp.py"]
