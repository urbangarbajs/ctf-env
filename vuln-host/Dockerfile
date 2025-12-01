FROM ubuntu:22.04

RUN apt-get update && apt-get install -y sudo vim-tiny net-tools \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m clinuser

# sudo misconfiguration for CTF
RUN echo "clinuser ALL=(ALL) NOPASSWD:/usr/local/bin/backup.sh" >> /etc/sudoers

COPY backup.sh /usr/local/bin/backup.sh
COPY final_flag.txt /root/final_flag.txt

RUN chmod +x /usr/local/bin/backup.sh

USER clinuser
WORKDIR /home/clinuser

CMD ["/bin/bash", "-c", "sleep infinity"]
