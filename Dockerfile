FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-terminal \
    xfce4-goodies \
    xrdp \
    dbus-x11 \
    curl \
    unzip \
    sudo \
    python3 \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
    | tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
    && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" \
    | tee /etc/apt/sources.list.d/ngrok.list \
    && apt-get update && apt-get install -y ngrok

RUN useradd -m -s /bin/bash rdpuser && \
    echo "rdpuser:MyPassword123" | chpasswd && \
    adduser rdpuser sudo && \
    adduser xrdp ssl-cert

RUN echo "xfce4-session" > /home/rdpuser/.xsession && \
    chown rdpuser:rdpuser /home/rdpuser/.xsession

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
