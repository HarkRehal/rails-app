#!/bin/bash
set -e

echo "🚀 DEPLOYING HARKI'S RAILS APP TO EC2"
echo "==================================="

# Cleanup
docker stop $(docker ps -q) 2>/dev/null || true
docker system prune -af --volumes

# Setup
mkdir -p /tmp/rails-deploy
cd /tmp/rails-deploy

# Download configuration
git clone https://github.com/HarkRehal/rails-app.git .

# Download and load the working AMD64 image
echo "📦 Downloading working AMD64 image (367MB)..."
curl -L -o rails-app-amd64.tar.gz https://github.com/HarkRehal/rails-app/releases/download/v1.0/rails-app-amd64.tar.gz

echo "📦 Loading Docker image..."
docker load < rails-app-amd64.tar.gz

# Update docker-compose to use the loaded image
cat > docker-compose.ec2.yml << 'EOF'
services:
  db:
    image: postgres:15
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
      POSTGRES_DB: rails_app_development

  web:
    image: rails-app-amd64:latest
    ports:
      - "3001:3000"
    depends_on:
      - db
    environment:
      DATABASE_URL: postgres://postgres:password@db/rails_app_development

volumes:
  postgres_data:
EOF

# Start the application
echo "🚀 Starting application..."
docker-compose -f docker-compose.ec2.yml up -d

# Wait and setup database
echo "⏳ Waiting for startup..."
sleep 20

echo "🗄️ Setting up database..."
docker-compose -f docker-compose.ec2.yml exec -T web rails db:create db:migrate

echo "👤 Creating admin user..."
docker-compose -f docker-compose.ec2.yml exec -T web rails runner "
User.find_or_create_by(email: 'admin@harkirehal.com') { |u| u.password = 'changeme123' }
Resume.find_or_create_by(id: 1) { |r| r.name = 'Harki Rehal'; r.title = 'AI & Technology Professional' }
"

echo ""
echo "🎉 SUCCESS! Rails app deployed!"
echo "📍 App running on port 3001"
echo "🌐 Test: curl http://localhost:3001"
echo "👤 Login: admin@harkirehal.com / changeme123"
echo ""
echo "🔧 Update your Nginx config to proxy / to localhost:3001"