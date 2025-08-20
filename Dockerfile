FROM debian:bookworm-slim
ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
       ca-certificates curl lib32gcc-s1 lib32stdc++6 procps tar xz-utils \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/steamcmd \
  && curl -sL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
     | tar -C /opt/steamcmd -xz

# Create server dir and non-root user
RUN useradd -m -s /bin/bash steam && mkdir -p /server && chown -R steam:steam /server /opt/steamcmd

# Copy entrypoint as root, set perms, normalize line endings
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown steam:steam /entrypoint.sh && sed -i 's/\r$//' /entrypoint.sh

# Now switch to steam and install the server
USER steam
WORKDIR /server

# Build-time install of Valheim dedicated server (AppID 896660)
RUN /opt/steamcmd/steamcmd.sh +login anonymous \
    +force_install_dir /server \
    +app_update 896660 validate \
    +quit

ENV SERVER_NAME="Simple Valheim Server" \
    WORLD_NAME="Dedicated" \
    SERVER_PASS="changeme" \
    SERVER_PUBLIC=1 \
    SERVER_PORT=2456 \
    SERVER_ARGS="" \
    ADMIN_LIST="" \
    TZ=UTC

EXPOSE 2456/udp 2457/udp 2458/udp

VOLUME ["/server"]
ENTRYPOINT ["/entrypoint.sh"]
