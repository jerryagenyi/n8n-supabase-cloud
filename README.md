# n8n + Supabase Docker Stack

A production-ready Docker Compose setup for running n8n workflow automation with Supabase PostgreSQL database.

## 🚀 Quick Start

1. **Clone and setup:**
   ```bash
   git clone <your-repo-url>
   cd n8n-supabase-cloud
   chmod +x setup.sh
   ./setup.sh
   ```

2. **Access your services:**
   - n8n: http://localhost:5678
   - Database: localhost:5432

## 📋 What's Included

- **n8n**: Workflow automation platform
- **Supabase PostgreSQL**: Database with extensions
- **Automated backups**: Volume backup/restore system
- **Make commands**: Easy management interface
- **Security best practices**: Environment-based configuration

## 🛠️ Management Commands

| Command | Description |
|---------|-------------|
| `make up` | Start all services |
| `make down` | Stop all services |
| `make restart` | Restart all services |
| `make logs` | View all logs |
| `make backup` | Backup all data |
| `make restore` | Restore from backup |

See [how-to-use-make.md](how-to-use-make.md) for complete command reference.

## 📁 Project Structure

```
├── docker-compose.yml    # Service definitions
├── .env                  # Environment variables (create from .env.example)
├── .env.example         # Environment template
├── Makefile             # Management commands
├── setup.sh             # Initial setup script
├── how-to-use-make.md   # Command reference
├── portability-btw-servers.md  # Migration guide
└── security-best.md     # Security practices
```

## 🔧 Configuration

1. Copy `.env.example` to `.env`
2. Update environment variables as needed
3. Run `./setup.sh` or `make up`

## 📚 Documentation

- [Make Commands Guide](how-to-use-make.md)
- [Server Migration Guide](portability-btw-servers.md)
- [Security Best Practices](security-best.md)

## 🔐 Security

- Environment variables stored in `.env` (not committed)
- Strong password defaults
- Volume-based data persistence
- See [security-best.md](security-best.md) for complete guide

## 🆘 Support

Check the documentation files for detailed guides on setup, migration, and security.
