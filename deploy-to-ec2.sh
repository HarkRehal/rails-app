#!/bin/bash

echo "🚀 DEPLOYING HARKI'S RAILS APP TO EC2"
echo "====================================="

# Step 1: Install Docker (if not installed)
sudo yum update -y
sudo yum install -y docker git
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user

# Step 2: Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Step 3: Create deployment directory
sudo mkdir -p /opt/rails-app
sudo chown ec2-user:ec2-user /opt/rails-app
cd /opt/rails-app

# Step 4: Clone the repository
git clone https://github.com/HarkRehal/rails-app.git .

# Step 5: Generate secrets
./generate_secrets.sh

# Step 6: Build and deploy
docker-compose -f docker-compose.production.yml build
docker-compose -f docker-compose.production.yml run --rm web rails db:create db:migrate

# Step 7: Create initial user and resume data
docker-compose -f docker-compose.production.yml run --rm web rails runner "
User.find_or_create_by(email: 'admin@harkirehal.com') do |user|
  user.password = 'changeme123'
end

Resume.find_or_create_by(id: 1) do |resume|
  resume.name = 'Harki Rehal'
  resume.title = 'AI & Technology Professional'
  resume.summary = 'Visionary global sales engineering leader with 20+ years of experience in fintech, core banking, and enterprise SaaS. Proven ability to scale high-performing SE teams across U.S., LATAM, and APAC regions while delivering value-focused pre-sales strategies, go-to-market readiness, and AI-driven product enablement.'
  resume.experience = 'Professional Experience\nPrincipal Sales Engineer – WithClutch | Oct 2024 – Present\nDirector of Sales Engineering – Technisys | Apr 2022 – Sep 2024\nDirector of Sales Engineering – Ondot Systems (Fiserv) | Jul 2018 – Mar 2022'
  resume.projects = 'AI Clone - Interactive AI platform\nAI Video Platform - Advanced video processing'
end
"

# Step 8: Start the application
docker-compose -f docker-compose.production.yml up -d

echo ""
echo "✅ RAILS APP DEPLOYED SUCCESSFULLY!"
echo "📍 Running on port 3001"
echo ""
echo "🔧 NEXT: Update your Nginx configuration"