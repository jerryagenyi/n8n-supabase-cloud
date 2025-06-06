# Podman Volumes Backup - Rclone

This folder contains automated backups of Podman volumes for the `n8n-supabase-cloud` project.

---

### Project Context:

* **Service**: n8n Workflow Automation Platform
* **VM**: Running on Google Cloud VM named "n8n-server" (specifically "n8n-server vm for n8n-workflows"), Project ID: `eternal-insight-452801-b4`.
* **Database Setup**:
    * **Local PostgreSQL (n8n-db)**: Uses postgres:15-alpine image for n8n's main operational data (workflows, credentials, executions). This is configured via DB_TYPE=postgresdb and DB_POSTGRESDB_HOST=n8n-db in the .env file. Data is safely stored in the `n8n-supabase-cloud_n8n-db-data` volume.
    * **Online Supabase (Vector DB)**: Remote Supabase instance used for vector operations. Connection is configured through Supabase environment variables in .env (no local volume needed).

---

### Backup Details:

* **Source Volumes**:
    * `n8n-supabase-cloud_n8n-data` (n8n application configuration and settings)
    * `n8n-supabase-cloud_n8n-db-data` (PostgreSQL database files for n8n's operational data)
* **Method**: Backups are generated locally on the VM using the `make backup` command (which tars the volumes to the `./backups` directory on the VM). These local backups are then synced to this Google Drive folder using `rclone`.
* **Generated By**: `rclone` (configured on the `n8n-server` VM).
* **Last Backup**: [Insert Date and Time of last backup, e.g., YYYY-MM-DD HH:MM UTC]
* **Retention Policy**: [Optional: e.g., "Keep last 7 daily backups, 4 weekly, 1 monthly."]

---

### How to Restore (General Steps):

1.  **Download Backup**: Download the desired `.tar.gz` backup file(s) from this folder to your VM.
2.  **Place Locally**: Place them in the `./backups` directory of your `n8n-supabase-cloud` project.
3.  **Stop n8n**: Ensure n8n and DB containers are down (`make down`).
4.  **Restore**: Use `make restore` command.
5.  **Start n8n**: Bring up the stack (`make up`).

---

### Important Notes:

* This folder should primarily be managed by `rclone` for automated syncing.
* Avoid manual modifications inside this folder unless absolutely necessary for restoration.
* For detailed recovery instructions, refer to the `portability-btw-servers.md` and `how-to-use-make.md` files within the `n8n-supabase-cloud` project repository.