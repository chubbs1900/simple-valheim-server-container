# Simple Valheim Server Container 🛡️🌲

Launch a **Valheim dedicated server** in Docker with a **single folder** for backups and **drag-and-drop mod support** (BepInEx/r2modman).  
Target game build: **0.220.5**. This image **does not auto-update** at runtime; update by rebuilding when your mods are ready.

## Features
- One volume (`/server`) holds binaries, saves, logs, configs, and (optionally) BepInEx/mods
- Portainer-friendly `docker-compose.yml`
- Env-var configuration; `SERVER_ARGS` for advanced flags/world modifiers
- Cross-platform (Windows/macOS/Linux with Docker)

## Quick Start (Portainer)
Use this compose in a Portainer stack (adjust paths/vars):

```yaml
version: "3.8"
services:
  valheim:
    image: ghcr.io/REPLACE_ME/simple-valheim-server-container:latest
    container_name: valheim_server
    environment:
      - TZ=America/New_York
      - SERVER_NAME=My Valheim Server
      - WORLD_NAME=Dedicated
      - SERVER_PASS=changeme
      - SERVER_PUBLIC=1
      - SERVER_PORT=2456
      - ADMIN_LIST=
      - SERVER_ARGS=
    volumes:
      - "C:/Valheim Server:/server"  # Windows example
    ports:
      - "2456:2456/udp"
      - "2457:2457/udp"
      - "2458:2458/udp"
    restart: unless-stopped
```

Mods (BepInEx / r2modman)

Export/copy your r2modman profile contents into the host folder you mapped to /server.
Place BepInEx files next to valheim_server.x86_64 within that folder. No extra steps are needed.

Configuration
Env VarDefaultNotes
SERVER_NAMESimple Valheim ServerName in server browser
WORLD_NAMEDedicatedSave name
SERVER_PASSchangeme5–10 chars
SERVER_PUBLIC11=public, 0=private
SERVER_PORT2456UDP 2456–2458 are exposed
ADMIN_LIST(blank)Steam64 IDs separated by commas/spaces/newlines
SERVER_ARGS(blank)Advanced flags/world modifiers (e.g., -crossplay -saveinterval 600)
TZUTCContainer timezone
Update Policy

This image pulls the Valheim server at build time. To update the game version, rebuild the image and redeploy.

Local Dev
docker build -t simple-valheim .
docker run -d --name valheim \
  -p 2456:2456/udp -p 2457:2457/udp -p 2458:2458/udp \
  -e SERVER_NAME="My Valheim" \
  -e WORLD_NAME="Dedicated" \
  -e SERVER_PASS="changeme" \
  -v "$PWD/server-data:/server" \
  simple-valheim

License

MIT
