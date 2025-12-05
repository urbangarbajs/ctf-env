FROM ubuntu:22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    xrdp xfce4 xfce4-terminal dbus-x11 sudo && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash HC-ADMIN && echo "HC-ADMIN:Adm1nHC!2025" | chpasswd && adduser HC-ADMIN sudo

COPY final_flag.txt /home/HC-ADMIN/Desktop/final_flag.txt
RUN chown HC-ADMIN:HC-ADMIN /home/HC-ADMIN/Desktop/final_flag.txt

# Configure XRDP to start XFCE
RUN echo "startxfce4" > /home/HC-ADMIN/.xsession && \
    chown HC-ADMIN:HC-ADMIN /home/HC-ADMIN/.xsession

COPY start-rdp.sh /usr/local/bin/start-rdp.sh
RUN chmod +x /usr/local/bin/start-rdp.sh

EXPOSE 3389

CMD ["/usr/local/bin/start-rdp.sh"]
