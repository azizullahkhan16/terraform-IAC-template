#!/bin/bash

sudo dnf update -y

# Install Nginx
dnf install nginx -y
systemctl start nginx
systemctl enable nginx

dnf install docker -y
systemctl start docker
systemctl enable docker
# Add ec2-user to docker group
usermod -a -G docker ec2-user

sudo mkdir -p /opt/metabase-data
sudo chown ec2-user:ec2-user /opt/metabase-data

docker run -d -p 3000:3000 -e MB_DB_FILE=/metabase-data/metabase.db   -v /opt/metabase-data:/metabase-data   --name metabase metabase/metabase

cat <<EOF | sudo tee /etc/nginx/conf.d/nodeapp.conf
server {
    listen 80;
    server_name mb.azizullahkhan.tech;
    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
 


}
EOF

sudo nginx -t && sudo systemctl restart nginx