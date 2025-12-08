FROM ubuntu:22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openssh-server rsync sudo gnupg && \
    rm -rf /var/lib/apt/lists/*

# rsync may create a system user 'backup'; tolerate existing
RUN if ! id -u backup >/dev/null 2>&1; then useradd -m -s /bin/bash backup; fi && \
    usermod -s /bin/bash -d /home/backup backup && \
    mkdir -p /home/backup && chown backup:backup /home/backup && \
    echo "backup:HealthyBackup2025!" | chpasswd
RUN mkdir -p /var/run/sshd

# Sudo misconfiguration for privilege escalation
RUN echo "backup ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/backup

COPY sshd_config /etc/ssh/sshd_config
COPY rsyncd.conf /etc/rsyncd.conf
COPY user_flag.txt /home/backup/user_flag.txt
COPY root_flag.txt /root/root_flag.txt
COPY passwords_plain.txt /tmp/passwords_plain.txt
COPY start-backup.sh /usr/local/bin/start-backup.sh

RUN chown backup:backup /home/backup/user_flag.txt
RUN chmod +x /usr/local/bin/start-backup.sh

# Create GPG encrypted vault with passphrase MRN-2025-CTF-01!
RUN gpg --batch --yes --passphrase "MRN-2025-CTF-01!" -c /tmp/passwords_plain.txt && \
    mv /tmp/passwords_plain.txt.gpg /root/passwords.gpg && \
    rm /tmp/passwords_plain.txt

EXPOSE 22 873

CMD ["/usr/local/bin/start-backup.sh"]
