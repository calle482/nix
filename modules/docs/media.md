# Nix Media Server Module

This Nix module configures a media server with various applications, network configurations, and systemd services. It provides an automated setup for media management tools, torrenting, and networking via WireGuard.

## Included Services

### Users & Groups
- Creates a `media` group.
- Creates a `media` user and adds it to `media` and `jellyfin` groups.

### Installed Packages
- `jellyfin`
- `jellyfin-web`
- `jellyfin-ffmpeg`
- `qbittorrent-nox`
- `wireguard-tools`

### Configured Services

#### Media Services
- **Jellyfin**
  - Enabled and configured with custom directories for logs, cache, data, and config.
  - Runs as the `media` user and group.

- **Radarr**
  - Enabled and configured with a custom data directory.
  - Runs as the `media` user and group.

- **Sonarr**
  - Enabled and configured with a custom data directory.
  - Runs as the `media` user and group.

- **Prowlarr**
  - Enabled with firewall access.

- **Bazarr**
  - Enabled and runs as the `media` user and group.

#### Torrenting
- **qBittorrent**
  - Enabled with firewall access.
  - Runs as the `media` user and group.
  - Uses port `1234`.
  - Profile stored in `/apps/qbittorrent`.

#### Network Configuration
- Sets DNS server to `10.128.0.1`.
- Creates a network namespace for WireGuard (`netns@wg.service`).
- Configures WireGuard (`wg.service`) with IP settings and routes.

#### Binding Services to WireGuard
- Services (`qbittorrent`, `radarr`, `sonarr`, `prowlarr`) are bound to the `wg` network namespace.

#### Socket Proxy Services
- Proxies allow services in the `wg` namespace to be accessible via sockets:
  - **qBittorrent** (`8080`)
  - **Radarr** (`7878`)
  - **Sonarr** (`8989`)
  - **Prowlarr** (`9696`)

### Persistent Storage
The following directories are persisted under `/persistent`:
- `/apps/jellyfin`
- `/apps/radarr`
- `/apps/sonarr`
- `/apps/qbittorrent`

This ensures data is retained across reboots.

---
This module is designed to provide a complete media management solution within NixOS, integrating media services with torrenting and a secure network setup using WireGuard.
