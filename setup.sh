#!/bin/bash

set -e

# Define default values (edit these if needed)
ENV_FILE=".env"
ENV_TEMPLATE=".env.example"
COMPOSE_FILE="docker-compose.yml"
VOLUMES=("n8n-data" "supabase-data")

echo "🔧 Initializing your local n8n + Supabase stack..."

# Step 1: Check for Docker and Docker Compose
if ! command -v docker &> /dev/null; then
  echo "❌ Docker is not installed. Please install Docker and try again."
  exit 1
fi

if ! command -v docker compose &> /dev/null; then
  echo "❌ Docker Compose V2 not found. Use Docker Desktop or upgrade to Docker Compose V2 (>= v2.0)."
  exit 1
fi

# Step 2: Create .env from example or prompt user
if [ ! -f "$ENV_FILE" ]; then
  echo "🧪 No .env file found. Creating one for you..."
  cat <<EOF > $ENV_FILE
# Database
POSTGRES_PASSWORD=supersecurepass
POSTGRES_USER=postgres
POSTGRES_DB=postgres

# n8n Auth
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=supersecureadminpass

# n8n config
N8N_HOST=localhost
WEBHOOK_URL=http://localhost:5678
EOF
  echo "✅ Default .env file created. You can edit it now: $ENV_FILE"
else
  echo "✅ Existing .env found. Skipping creation."
fi

# Step 3: Create named volumes if not already existing
for VOL in "${VOLUMES[@]}"; do
  if ! docker volume inspect "$VOL" &> /dev/null; then
    docker volume create "$VOL"
    echo "✅ Volume $VOL created."
  else
    echo "ℹ️ Volume $VOL already exists."
  fi
done

# Step 4: Start the stack
echo "🚀 Starting services with Docker Compose..."
docker compose up -d

echo "🎉 Setup complete! Access n8n at: http://localhost:5678"
