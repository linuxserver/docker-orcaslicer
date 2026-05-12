# Snapmaker OrcaSlicer Docker Container

**Snapmaker Fork of OrcaSlicer** - Web accessible OrcaSlicer inside a Debian Container

This is a custom fork that uses [Snapmaker's OrcaSlicer](https://github.com/Snapmaker/OrcaSlicer) instead of the vanilla version. The image is automatically synchronized with the upstream [linuxserver/docker-orcaslicer](https://github.com/linuxserver/docker-orcaslicer) repository while maintaining Snapmaker-specific customizations.

## Quick Start

### Docker Compose (Recommended)

```yaml
---
services:
  orcaslicer:
    image: ghcr.io/totalitarian/docker-snapmakerorcaslicer:latest
    container_name: orcaslicer-snapmaker
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - /path/to/config:/config
    ports:
      - 3000:3000
      - 3001:3001
    shm_size: "1gb"
    restart: unless-stopped
```

### Docker CLI

```bash
docker run -d \
  --name=orcaslicer-snapmaker \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 3000:3000 \
  -p 3001:3001 \
  -v /path/to/config:/config \
  --shm-size="1gb" \
  --restart unless-stopped \
  ghcr.io/totalitarian/docker-snapmakerorcaslicer:latest
```

## Access

Once running, access the application at:
- **HTTP:** `http://yourhost:3000/`
- **HTTPS:** `https://yourhost:3001/`

## Environment Variables

| Variable | Description | Default |
| :----: | --- | --- |
| `PUID` | UserID for permissions | `1000` |
| `PGID` | GroupID for permissions | `1000` |
| `TZ` | Timezone | `Etc/UTC` |
| `PIXELFLUX_WAYLAND` | Enable Wayland mode | `true` |
| `CUSTOM_USER` | HTTP Basic auth username | `abc` |
| `PASSWORD` | HTTP Basic auth password | (none) |

## Features

- ✅ **Snapmaker OrcaSlicer** - Optimized for Snapmaker 3D printers
- ✅ **Auto-synced** - Automatically syncs with upstream linuxserver updates daily
- ✅ **Container Updates** - Automatically built and published to GHCR
- ✅ **Wayland Support** - Modern Wayland stack with zero-copy encoding
- ✅ **GPU Acceleration** - Optional Intel, AMD, and Nvidia GPU support
- ✅ **Web-based** - Access from any browser

## GPU Acceleration

### Intel/AMD (VAAPI)

```yaml
services:
  orcaslicer:
    image: ghcr.io/totalitarian/docker-snapmakerorcaslicer:latest
    devices:
      - /dev/dri:/dev/dri
    environment:
      - PIXELFLUX_WAYLAND=true
      - DRINODE=/dev/dri/renderD128
      - DRI_NODE=/dev/dri/renderD128
```

### Nvidia (NVENC)

```yaml
services:
  orcaslicer:
    image: ghcr.io/totalitarian/docker-snapmakerorcaslicer:latest
    environment:
      - PIXELFLUX_WAYLAND=true
      - DRINODE=/dev/dri/renderD128
      - DRI_NODE=/dev/dri/renderD128
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [compute,video,graphics,utility]
```

## Security

⚠️ **WARNING:** This container provides privileged access to the host system. Do not expose it to the Internet unless properly secured.

**Recommendations:**
- Use HTTPS only (required for WebCodecs)
- Set `CUSTOM_USER` and `PASSWORD` for basic authentication
- Use a reverse proxy with authentication
- Keep container on a trusted network

## Image Tags

- `latest` - Latest build from master branch
- `master-<sha>` - Specific commit SHA
- `<date>` - Build date tag

All tags are pushed to: `ghcr.io/totalitarian/docker-snapmakerorcaslicer`

## Building Locally

```bash
git clone https://github.com/totalitarian/docker-snapmakerorcaslicer.git
cd docker-snapmakerorcaslicer
docker build -t snapmaker-orcaslicer:local .
docker run -d \
  -p 3000:3000 \
  -p 3001:3001 \
  -v /path/to/config:/config \
  --shm-size="1gb" \
  snapmaker-orcaslicer:local
```

## Updating

### Auto-updates via Docker

```bash
docker-compose pull
docker-compose up -d
```

### Manual Update

```bash
docker pull ghcr.io/totalitarian/docker-snapmakerorcaslicer:latest
docker stop orcaslicer-snapmaker
docker rm orcaslicer-snapmaker
# Re-run the docker run command from above
```

## Synchronization with Upstream

This fork automatically:
1. **Syncs daily** with `linuxserver/docker-orcaslicer` master branch
2. **Rebases** Snapmaker customizations on top of upstream changes
3. **Creates PRs** for manual review of conflicts
4. **Builds and publishes** new images to GHCR

Workflow: `.github/workflows/sync-upstream.yml`

## References

- [Snapmaker OrcaSlicer](https://github.com/Snapmaker/OrcaSlicer) - Snapmaker fork of OrcaSlicer
- [Upstream linuxserver](https://github.com/linuxserver/docker-orcaslicer) - Original LinuxServer container
- [OrcaSlicer](https://github.com/SoftFever/OrcaSlicer) - Original OrcaSlicer project
- [Snapmaker](https://www.snapmaker.com/) - Snapmaker 3D printer manufacturer

## License

GNU General Public License v3.0 - see LICENSE file

## Support

For issues specific to:
- **Snapmaker integration** - Open an issue on this repository
- **OrcaSlicer features** - See [OrcaSlicer GitHub](https://github.com/SoftFever/OrcaSlicer)
- **Container setup** - See [linuxserver documentation](https://docs.linuxserver.io)
