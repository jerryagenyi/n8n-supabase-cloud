PROJECT_NAME=n8n-stack
N8N_VOLUME=n8n-data
DB_VOLUME=supabase-data
BACKUP_DIR=./backups

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose down && docker compose up -d

backup:
	mkdir -p $(BACKUP_DIR)
	docker run --rm -v $(N8N_VOLUME):/volume -v $(PWD)/$(BACKUP_DIR):/backup alpine \
		tar czf /backup/n8n-data.tar.gz -C /volume .
	docker run --rm -v $(DB_VOLUME):/volume -v $(PWD)/$(BACKUP_DIR):/backup alpine \
		tar czf /backup/supabase-data.tar.gz -C /volume .
	@echo "✅ Backup complete: stored in $(BACKUP_DIR)/"

restore:
	docker volume create $(N8N_VOLUME)
	docker volume create $(DB_VOLUME)
	docker run --rm -v $(N8N_VOLUME):/volume -v $(PWD)/$(BACKUP_DIR):/backup alpine \
		tar xzf /backup/n8n-data.tar.gz -C /volume
	docker run --rm -v $(DB_VOLUME):/volume -v $(PWD)/$(BACKUP_DIR):/backup alpine \
		tar xzf /backup/supabase-data.tar.gz -C /volume
	@echo "✅ Restore complete from $(BACKUP_DIR)/"

clean-volumes:
	docker volume rm $(N8N_VOLUME) $(DB_VOLUME)

logs:
	docker compose logs -f

logs-n8n:
	docker compose logs -f n8n

logs-db:
	docker compose logs -f supabase-db

status:
	docker compose ps

.PHONY: up down restart backup restore clean-volumes logs logs-n8n logs-db status
