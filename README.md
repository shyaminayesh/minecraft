# Dockerize Minecraft

A containerized Minecraft server with automatic version downloading and persistent storage.

## Features

- Multi-stage Docker build for optimized image size
- Automatic server.jar download from Mojang's official API
- Version-specific builds using build arguments
- Persistent world and configuration data via volume mounts
- Easy deployment with docker-compose

## Prerequisites

- Docker
- Docker Compose (optional, but recommended)

## Quick Start

### Using Docker Compose (Recommended)

1. Set up your configuration files:
```bash
touch server.properties ops.json whitelist.json banned-players.json banned-ips.json usercache.json
```

2. Start the server:
```bash
docker-compose up -d
```

3. View logs:
```bash
docker-compose logs -f minecraft
```

4. Attach to console:
```bash
docker attach minecraft
```

5. Stop the server:
```bash
docker-compose down
```

### Using Docker CLI

```bash
docker run -d \
  --name minecraft \
  -p 25565:25565 \
  -v ./world:/app/world \
  -v ./server.properties:/app/server.properties \
  -v ./ops.json:/app/ops.json \
  -v ./whitelist.json:/app/whitelist.json \
  -v ./banned-players.json:/app/banned-players.json \
  -v ./banned-ips.json:/app/banned-ips.json \
  -v ./usercache.json:/app/usercache.json \
  ghcr.io/shyaminayesh/minecraft:1.21.10
```

## Configuration

### Server Configuration

Edit `server.properties` to configure your server settings:
- Server port (default: 25565)
- Game mode (survival, creative, adventure)
- Difficulty
- Max players
- World settings

### Player Management

- `ops.json` - Server operators with admin privileges
- `whitelist.json` - Whitelisted players (if whitelist is enabled)
- `banned-players.json` - Banned players
- `banned-ips.json` - Banned IP addresses
- `usercache.json` - Player name to UUID cache (auto-generated)

## File Structure

```
.
├── Dockerfile           # Multi-stage build definition
├── docker-compose.yaml  # Docker Compose configuration
├── fetch.sh            # Script to download server.jar
├── .dockerignore       # Files excluded from Docker build
├── eula.txt            # Minecraft EULA acceptance
├── server.properties   # Server configuration (mounted)
├── ops.json            # Server operators (mounted)
├── whitelist.json      # Whitelisted players (mounted)
├── banned-players.json # Banned players (mounted)
├── banned-ips.json     # Banned IPs (mounted)
├── usercache.json      # Player UUID cache (mounted)
└── world/              # World data (mounted)
```

## Backup

### Files to Backup

The following files contain all your server data:
- `world/` - World data (terrain, builds, entities)
- `server.properties` - Server configuration
- `ops.json` - Server operators
- `whitelist.json` - Whitelisted players
- `banned-players.json` - Banned players
- `banned-ips.json` - Banned IPs
- `usercache.json` - Player UUID cache (optional, regenerates automatically)

### Manual Backup

```bash
tar -czf minecraft-backup-$(date +%Y%m%d).tar.gz \
  world/ \
  server.properties \
  ops.json \
  whitelist.json \
  banned-players.json \
  banned-ips.json \
  usercache.json
```

## Environment Variables

### Docker Compose

You can override settings in `docker-compose.yaml`:
- Port mapping (default: 25565:25565)
- Memory allocation (edit CMD in Dockerfile)
- Restart policy (default: unless-stopped)

## License

This project is for educational purposes. Minecraft is owned by Mojang/Microsoft. Server distribution must comply with Minecraft's EULA.

## Notes

- Do NOT commit `server.jar`, `libraries/`, or `versions/` to Git (copyright violation)
- Player data files may contain personal information (privacy concerns)
- World data should be backed up regularly
