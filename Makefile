PROJECT_NAME=n8n-stack
N8N_VOLUME=n8n-data
DB_VOLUME=supabase-data
BACKUP_DIR=./backups

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

.PHONY: up down restart backup restore clean-volumes logs logs-n8n logs-db status
