# 🔐 Security & Portability Best Practices

This guide outlines essential security practices for your n8n + Supabase stack.

## 🛡️ Core Security Practices

| Best Practice | Why It Matters | Implementation |
|---------------|----------------|----------------|
| Use `.env` files | Keeps secrets out of `docker-compose.yml`. Easier to rotate/change credentials. | Store all sensitive data in `.env`, never commit to git |
| Set `restart: unless-stopped` | More resilient than `always` in case you stop containers manually. | Already configured in `docker-compose.yml` |
| Mount named volumes | Easily portable using docker volume export/import or volume backup tools. | Use named volumes instead of bind mounts |
| HTTPS for webhook URLs | Ensures secure communication if public. | Use SSL certificates for production |
| Network segmentation | Use Docker networks if adding more services later. | Create custom networks for isolation |
| Back up volumes regularly | For data durability. Use tools like `docker cp` or volumerize. | Use `make backup` command regularly |
| Keep secrets outside container | Use Docker Secrets or a vault for production deployments. | Never hardcode secrets in images |

## 🔒 Environment-Specific Security

### Local Development

- **URLs**: Use `http://localhost` URLs (as configured in your `.env`)
- **Passwords**: Use strong but memorable passwords for development
- **Access**: Restrict to localhost only
- **Backups**: Regular backups to prevent data loss during development

### Production Deployment

- **HTTPS**: Switch to HTTPS domains and proper SSL certificates
- **Strong Passwords**: Use complex, randomly generated passwords
- **Database**: Consider using connection pooling for production workloads
- **Monitoring**: Add health checks and logging for production environments
- **Firewall**: Restrict access to necessary ports only
- **Updates**: Keep Docker images updated regularly

## 🚨 Security Checklist

### Before Deployment

- [ ] All passwords are strong and unique
- [ ] `.env` file is not committed to version control
- [ ] SSH keys and certificates are properly secured
- [ ] Database is not exposed to public internet unnecessarily
- [ ] HTTPS is configured for production
- [ ] Backup strategy is in place

### Regular Maintenance

- [ ] Update Docker images monthly
- [ ] Rotate passwords quarterly
- [ ] Review access logs regularly
- [ ] Test backup and restore procedures
- [ ] Monitor for security vulnerabilities

## 🔧 Security Commands

```bash
# Check for exposed ports
docker compose ps

# View container security info
docker inspect n8n-stack-n8n-1 | grep -i security

# Check volume permissions
docker run --rm -v n8n-data:/volume alpine ls -la /volume

# Monitor logs for suspicious activity
make logs | grep -i error
```

## 🚫 What NOT to Do

- ❌ Don't commit `.env` files to git
- ❌ Don't use default passwords in production
- ❌ Don't expose database ports publicly unless necessary
- ❌ Don't store SSH keys in the repository
- ❌ Don't run containers as root in production
- ❌ Don't ignore security updates

## 📚 Additional Resources

- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [n8n Security Documentation](https://docs.n8n.io/hosting/security/)
- [PostgreSQL Security Guide](https://www.postgresql.org/docs/current/security.html)