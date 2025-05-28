# 🔄 Portability Between Servers

This guide helps you migrate your n8n + Supabase stack to a new server while preserving all data and configurations.

## 📋 Prerequisites

- Docker and Docker Compose installed on the new server
- Access to backup files from the old server
- Network connectivity between servers (if doing live migration)

## 🚀 Migration Steps

### 1. **Prepare Essential Files**

Copy these files from your old server to the new one:

- `.env` (your environment variables)
- `docker-compose.yml` (service configuration)
- `Makefile` (optional, for convenience commands)
- Any backup files from `./backups/` directory

### 2. **Create Docker Volumes**

On the new server, create the required volumes:

```bash
docker volume create supabase-data
docker volume create n8n-data
```

### 3. **Backup and Restore Data**

#### Option A: Using Make Commands (Recommended)

```bash
# On old server - create backup
make backup

# Copy backup files to new server
scp -r ./backups/ user@new-server:/path/to/project/

# On new server - restore from backup
make restore
```

#### Option B: Manual Volume Operations

```bash
# Backup a volume (run on old server)
docker run --rm -v <volume-name>:/volume -v $(pwd):/backup alpine \
  tar czf /backup/volume.tar.gz -C /volume .

# Restore a volume (run on new server)
docker run --rm -v <volume-name>:/volume -v $(pwd):/backup alpine \
  tar xzf /backup/volume.tar.gz -C /volume
```

### 4. **Start the Stack**

```bash
# Using Make (recommended)
make up

# Or using Docker Compose directly
docker compose up -d
```

### 5. **Verify Migration**

```bash
# Check container status
make status

# View logs to ensure everything is working
make logs
```

## ✅ Post-Migration Checklist

- [ ] n8n is accessible at `http://localhost:5678` (or your configured URL)
- [ ] Database connection is working
- [ ] All workflows are present and functional
- [ ] Webhook URLs are updated if domain changed
- [ ] SSL certificates are configured (for production)

## 🔧 Troubleshooting

### Common Issues

1. **Permission errors**: Ensure Docker has proper permissions on the new server
2. **Port conflicts**: Check if ports 5432 and 5678 are available
3. **Environment variables**: Verify `.env` file is properly configured
4. **Network issues**: Ensure containers can communicate with each other

### Useful Commands

```bash
# Check container logs
make logs-n8n
make logs-db

# Restart services if needed
make restart

# Check volume contents
docker run --rm -v n8n-data:/volume alpine ls -la /volume
```

Your data and environment will persist across servers! 🎉