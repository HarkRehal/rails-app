#!/bin/bash

# Deployment script for EC2
echo "🚀 Deploying Rails app to EC2..."

# Step 1: Create deployment directory
sudo mkdir -p /opt/rails-app
cd /opt/rails-app

# Step 2: Clone or update the repository
if [ -d ".git" ]; then
    echo "📥 Updating existing repository..."
    git pull origin main
else
    echo "📥 Cloning repository..."
    # Replace with your actual git repository URL
    git clone https://github.com/yourusername/rails-app.git .
fi

# Step 3: Generate production secrets
./generate_secrets.sh

# Step 4: Build and start the application
echo "🔨 Building Docker containers..."
docker-compose -f docker-compose.production.yml build

echo "🗄️  Running database migrations..."
docker-compose -f docker-compose.production.yml run --rm web rails db:create db:migrate

echo "🌱 Seeding database (creating initial user)..."
docker-compose -f docker-compose.production.yml run --rm web rails runner "
User.find_or_create_by(email: 'admin@harkirehal.com') do |user|
  user.password = 'changeme123'
end

Resume.find_or_create_by(id: 1) do |resume|
  resume.name = 'Harki Rehal'
  resume.title = 'AI & Technology Professional'
  resume.summary = 'Visionary global sales engineering leader with 20+ years of experience in fintech, core banking, and enterprise SaaS.'
end
"

echo "🚀 Starting the application..."
docker-compose -f docker-compose.production.yml up -d

echo ""
echo "✅ Rails app deployed and running on port 3001!"
echo ""
echo "🔧 NEXT STEPS - Update your Nginx configuration:"
echo "1. SSH to your EC2 instance"
echo "2. Edit your existing Nginx config file (usually /etc/nginx/sites-available/default)"
echo "3. Add the configuration from nginx-config-addition.conf"
echo "4. Test the config: sudo nginx -t"
echo "5. Reload Nginx: sudo systemctl reload nginx"
echo ""
echo "🌐 After Nginx update, your resume will be at: https://www.harkirehal.com"
echo "👤 Login with: admin@harkirehal.com / changeme123"
echo "🤖 Your existing /AskAI will continue to work"