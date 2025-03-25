# Nix Minecraft Server Module

This Nix module configures a Minecraft server using Fabric with persistence and network configurations.

## Included Services

### Installed Packages
- `fabricServers.fabric-1_21_4`

### Configured Services

- **Minecraft Server**
  - Enabled and configured with:
    - EULA acceptance
    - Firewall access
    - Data directory at `/apps/minecraft`
  - **Survival Server**
    - Enabled with Fabric support (`fabric-1_21_4`)
    - Server properties:
      - Gamemode: `survival`
      - Difficulty: `normal`
      - Simulation distance: `32`
    - Supports whitelisting (currently empty)
    - Downloads and installs mods from various sources, ensuring a customizable gameplay experience.

### Persistent Storage
The following directories are persisted under `/persistent`:
- `/apps/minecraft`

This ensures Minecraft world data and configurations are retained across reboots.

---
This module simplifies the setup of a Fabric-based Minecraft server on NixOS with built-in persistence and network access.
