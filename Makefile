PROJECT_NAME=n8n-stack
N8N_VOLUME=n8n-data
DB_VOLUME=supabase-data
BACKUP_DIR=./backups

# Cloudflare Tunnel Configuration
# IMPORTANT: Replace this with your actual Cloudflare Tunnel token
# You can obtain this from your Cloudflare Zero Trust Dashboard -> Tunnels -> Your Tunnel Name
CLOUDFLARED_TUNNEL_TOKEN = "eyJhIjoiYjVkOTg3Y2QxNDVmMjRiNDE0NjI2YjI1MWIxMzQ5NzIiLCJzIjoiZW5uUHVscFc0aHJZVk1jTDgneDUwSW5BSHk4NEJxdi9pN2s5WkpaNVRjUT0iLCJ0IjoiZDQ5MWMyOTYtZjk0Ni00MzJmLThjMjUtNjg1ZThjNWEzZjdjIn0="

up:
	podman-compose up -d

down:
	podman-compose down

restart:
	podman-compose down && podman-compose up -d

backup:
	mkdir -p $(BACKUP_DIR)
	podman run --rm -v $(N8N_VOLUME):/volume -v $(PWD)/$(BACKUP_DIR):/backup alpine \
		tar czf /backup/n8n-data.tar.gz -C /volume .
	podman run --rm -v $(DB_VOLUME):/volume -v $(PWD)/$(BACKUP_DIR):/backup alpine \
		tar czf /backup/supabase-data.tar.gz -C /volume .
	@echo "✅ Backup complete: stored in $(BACKUP_DIR)/"

restore:
	podman volume create $(N8N_VOLUME)
	podman volume create $(DB_VOLUME)
	podman run --rm -v $(N8N_VOLUME):/volume -v $(PWD)/$(BACKUP_DIR):/backup alpine \
		tar xzf /backup/n8n-data.tar.gz -C /volume
	podman run --rm -v $(DB_VOLUME):/volume -v $(PWD)/$(BACKUP_DIR):/backup alpine \
		tar xzf /backup/supabase-data.tar.gz -C /volume
	@echo "✅ Restore complete from $(BACKUP_DIR)/"

clean-volumes:
	podman volume rm $(N8N_VOLUME) $(DB_VOLUME)

logs:
	podman-compose logs -f

logs-n8n:
	podman-compose logs -f n8n

logs-db:
	podman-compose logs -f supabase-db

status:
	podman-compose ps

# Cloudflare Tunnel Commands
.PHONY: install-cloudflared start-cloudflared enable-cloudflared tunnel-status uninstall-cloudflared full-cloudflared-setup

install-cloudflared:
	@echo "--- Installing Cloudflare Tunnel service ---"
	sudo cloudflared service install $(CLOUDFLARED_TUNNEL_TOKEN)
	@echo "Cloudflare Tunnel service installed."

start-cloudflared:
	@echo "--- Starting Cloudflare Tunnel service ---"
	sudo systemctl start cloudflared.service
	@echo "Cloudflare Tunnel service started."

enable-cloudflared:
	@echo "--- Enabling Cloudflare Tunnel service to start on boot ---"
	sudo systemctl enable cloudflared.service
	@echo "Cloudflare Tunnel service enabled for boot."

tunnel-status:
	@echo "--- Checking Cloudflare Tunnel service status ---"
	sudo systemctl status cloudflared.service --no-pager

tunnel-logs:
	@echo "--- Viewing Cloudflare Tunnel service logs ---"
	sudo journalctl -u cloudflared.service -f

uninstall-cloudflared:
	@echo "--- Uninstalling Cloudflare Tunnel service ---"
	sudo cloudflared service uninstall
	@echo "Cloudflare Tunnel service uninstalled."

full-cloudflared-setup: install-cloudflared start-cloudflared enable-cloudflared
	@echo "--- Full Cloudflare Tunnel setup complete! ---"