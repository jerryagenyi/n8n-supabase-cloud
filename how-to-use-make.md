# How to Use Make Commands

Open terminal in your project folder and run any of the following:

## 🚀 Basic Commands

| Command | What It Does |
|---------|-------------|
| `make up` | Starts your n8n + Supabase stack |
| `make down` | Stops all containers |
| `make restart` | Restarts all containers |
| `make status` | Shows status of all containers |

## 📋 Monitoring Commands

| Command | What It Does |
|---------|-------------|
| `make logs` | Shows logs from all services |
| `make logs-n8n` | Shows logs from n8n service only |
| `make logs-db` | Shows logs from database service only |

## 💾 Backup & Restore Commands

| Command | What It Does |
|---------|-------------|
| `make backup` | Backs up both volumes to ./backups |
| `make restore` | Restores volumes from backup |
| `make clean-volumes` | Deletes both named volumes |

## Cloudflare Tunnel Commands

| Command                     | Description                                            |
|-----------------------------|--------------------------------------------------------|
| `make install-cloudflared`  | Installs the Cloudflare Tunnel system service          |
| `make start-cloudflared`    | Starts the Cloudflare Tunnel service                   |
| `make enable-cloudflared`   | Enables the Cloudflare Tunnel service to start on boot |
| `make full-cloudflared-setup` | Runs install, start, and enable for the tunnel service |
| `make tunnel-status`        | Checks the current status of the tunnel service        |
| `make tunnel-logs`          | Views real-time logs of the tunnel service             |
| `make uninstall-cloudflared`| Uninstalls the Cloudflare Tunnel service               |

💡 **Pro Tip:** Use `make logs` to monitor your services in real-time.

## 📦 What This Enables

- 🚀 Easy setup/teardown/restore when migrating servers
- 🔄 Reliable volume-level backups of both n8n and Supabase
- 🧹 Cleanup and recreate volumes cleanly if needed
- 🔒 Secure handling: no hardcoded passwords/scripts — uses .env