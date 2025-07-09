#!/bin/bash
set -e

echo "Starting deployment process..."

# Check if docker-compose.yml exists
if [ ! -f "docker-compose.yml" ]; then
    echo "docker-compose.yml not found. Creating a basic one..."
    cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
EOF
fi

# Deploy using docker-compose
echo "Deploying services..."
docker-compose up -d

echo "Deployment completed successfully!"