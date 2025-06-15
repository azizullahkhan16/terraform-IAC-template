#!/bin/bash

# Update system packages
sudo dnf update -y

# Install Nginx
dnf install nginx -y
systemctl start nginx
systemctl enable nginx

# Install Docker
dnf install docker -y
systemctl start docker
systemctl enable docker
# Add ec2-user to docker group
usermod -a -G docker ec2-user

# Install Node.js 20 (works natively on Amazon Linux 2023)
dnf install nodejs npm -y
dnf install -y git


# Use it in your script
echo "Connecting to: ${POSTGRES_URL}"

cd /home/ec2-user
git clone https://github.com/azizullahkhan16/shopping-list-frontend-devops
git clone https://github.com/azizullahkhan16/shopping-list-backend-devops
chown -R ec2-user:ec2-user shopping-list-frontend-devops
chown -R ec2-user:ec2-user shopping-list-backend-devops

docker network create myapp-network

cd shopping-list-backend-devops
docker build -t shopping-list-backend .
docker run -d --network myapp-network  --name backend  -p 5000:4000 -e DATABASE_URL="${POSTGRES_URL}" -e NODE_TLS_REJECT_UNAUTHORIZED=0 shopping-list-backend

cd ..

cd shopping-list-frontend-devops
docker build --build-arg REACT_APP_API_URL=/api/items -t shopping-list-frontend .
docker run -d -p 500:80 --name frontend --network myapp-network shopping-list-frontend



cat <<EOF | sudo tee /etc/nginx/conf.d/nodeapp.conf
server {
    listen 80;
    
    location / {
        proxy_pass http://127.0.0.1:500;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
   location /api/ {
        proxy_pass http://127.0.0.1:5000;  
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }


}
EOF

sudo nginx -t && sudo systemctl restart nginx

