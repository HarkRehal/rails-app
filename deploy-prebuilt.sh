#!/bin/bash
set -e

echo "🚀 DEPLOYING HARKI'S PRE-BUILT RAILS APP"
echo "========================================"

# Cleanup
echo "🧹 Cleaning up previous attempts..."
docker system prune -af --volumes
sudo rm -rf /opt/rails-app

# Setup directory
echo "📁 Setting up deployment directory..."
sudo mkdir -p /opt/rails-app
sudo chown ec2-user:ec2-user /opt/rails-app
cd /opt/rails-app

# Get deployment files
echo "📥 Getting deployment configuration..."
git clone https://github.com/HarkRehal/rails-app.git .

# Generate secrets
echo "🔐 Generating production secrets..."
./generate_secrets.sh

# Download and load the pre-built Docker image
echo "📦 Downloading your working Docker image (359MB)..."
curl -L -o rails-app-image.tar.gz https://github.com/HarkRehal/rails-app/releases/download/v1.0/rails-app-image.tar.gz

echo "📦 Loading Docker image..."
docker load < rails-app-image.tar.gz

# Start the application
echo "🚀 Starting application with your pre-built image..."
docker-compose -f docker-compose.prebuilt.yml up -d

# Wait for startup
echo "⏳ Waiting for services to start..."
sleep 15

# Setup database
echo "🗄️ Setting up database..."
docker-compose -f docker-compose.prebuilt.yml exec -T web rails db:create db:migrate

# Create user and data
echo "👤 Creating admin user and resume data..."
docker-compose -f docker-compose.prebuilt.yml exec -T web rails runner "
User.find_or_create_by(email: 'admin@harkirehal.com') do |user|
  user.password = 'changeme123'
end

Resume.find_or_create_by(id: 1) do |resume|
  resume.name = 'Harki Rehal'
  resume.title = 'AI & Technology Professional'
  resume.summary = 'Visionary global sales engineering leader with 20+ years of experience in fintech, core banking, and enterprise SaaS. Proven ability to scale high-performing SE teams across U.S., LATAM, and APAC regions while delivering value-focused pre-sales strategies, go-to-market readiness, and AI-driven product enablement.'
  resume.experience = 'Professional Experience

Principal Sales Engineer – WithClutch | Oct 2024 – Present
Led end-to-end SaaS solution architecture and implementation for digital onboarding platforms. Mapped credit union workflows, validated technical scope, and created project plans to accelerate time-to-value. Advised clients on governance models, platform extensibility, and risk mitigation.

Director of Sales Engineering – Technisys | Apr 2022 – Sep 2024
Designed API-first core and digital banking solutions. Advised C-level stakeholders on data governance, architecture blueprints, and technical roadmap planning. Managed solution rollout for global clients with complex business workflows.

Director of Sales Engineering – Ondot Systems (Fiserv) | Jul 2018 – Mar 2022
Founded Sales Engineering practice. Scaled solution design operations, delivered product demos, and worked with cross-functional teams to guide clients through onboarding, platform customization, and long-term adoption.

Business and Digital Solutions Consultant – Temenos | May 2016 – Jun 2018
Closed 7-figure SaaS core banking deals. Led client discovery, mapped workflows, and created tailored implementation plans. Advised regional banks and credit unions on best practices for integration and deployment.

Education
MBA – University of Florida
BS, Computer Engineering – University of Bombay
Marketing Strategy Certificate – Cornell University'
  resume.projects = 'AI Clone - Interactive AI platform that simulates natural conversation and learning

AI Video Platform - Advanced video processing and AI integration for enhanced content creation'
end
"

# Cleanup downloaded file
rm rails-app-image.tar.gz

echo ""
echo "🎉 SUCCESS! DEPLOYMENT COMPLETE!"
echo "=================================="
echo "📍 Rails app is running on port 3001"
echo "🌐 Test locally: curl http://localhost:3001"
echo "👤 Admin login: admin@harkirehal.com / changeme123"
echo ""
echo "📊 Container status:"
docker ps | grep rails-app
echo ""
echo "🔧 NEXT: Update your Nginx configuration to route www.harkirehal.com"
echo "   Add this to your Nginx config:"
echo "   location / { proxy_pass http://localhost:3001; }"