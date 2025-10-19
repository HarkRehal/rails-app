#!/bin/bash

# Generate production secrets
echo "Generating production secrets..."

# Generate SECRET_KEY_BASE
SECRET_KEY_BASE=$(openssl rand -hex 64)

# Generate POSTGRES_PASSWORD
POSTGRES_PASSWORD=$(openssl rand -base64 32)

# Check if master.key exists, if not create it
if [ ! -f "config/master.key" ]; then
    echo "Generating Rails master key..."
    docker-compose run --rm web rails secret > config/master.key
fi

RAILS_MASTER_KEY=$(cat config/master.key 2>/dev/null || echo "")

# Create .env.production file
cat > .env.production << EOF
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
SECRET_KEY_BASE=${SECRET_KEY_BASE}
RAILS_MASTER_KEY=${RAILS_MASTER_KEY}
EOF

echo "✅ Production secrets generated in .env.production"
echo "⚠️  Keep this file secure and don't commit it to version control!"