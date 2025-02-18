#!/bin/bash

# Prompt the user for input
echo "Please enter your sol address:"
read address

# Update the package list
sudo apt update

# Install necessary packages
sudo apt install -y x11vnc openssh-server curl

# Create and write the systemd service content to the file
SERVICE_FILE="/lib/systemd/system/x11vnc.service"

echo "[Unit]
Description=x11vnc service
After=display-manager.service network.target syslog.target

[Service]
Type=simple
ExecStart=/usr/bin/x11vnc -forever -display :0 -auth guess -passwd password
ExecStop=/usr/bin/killall x11vnc
Restart=on-failure

[Install]
WantedBy=multi-user.target" | sudo tee $SERVICE_FILE > /dev/null

# Reload systemd to apply the new service
sudo systemctl daemon-reload

# Enable the x11vnc service to start on boot
sudo systemctl enable x11vnc.service

# Start the x11vnc service
sudo systemctl start x11vnc.service

# Check the status of the service
#systemctl status x11vnc.service

# Install and configure OpenSSH server
#sudo systemctl status ssh
sudo ufw allow ssh

# Display IP address
ip a

# Set up UFW firewall
sudo ufw enable
sudo ufw allow from any to any port 53,37964,5353,48363 proto udp
sudo ufw allow from any to any port 22,80,443,5900,631,3389,8003 proto tcp

# Show UFW status
sudo ufw status

# Install curl if it's not already installed
sudo apt-get install -y curl

# Download the compiled pop binary
curl -L -o pop "https://dl.pipecdn.app/v0.2.6/pop"

# Assign executable permission to the pop binary
chmod +x pop

# Create folder to be used for download cache
mkdir -p download_cache

# Run the pop application with the specified parameters
sudo ./pop --signup-by-referral-route f5475846a58338ff \
./pop
  --ram 4 \              # RAM in GB
  --max-disk 150 \       # Max disk usage in GB  
  --cache-dir /data \    # Cache location
  --pubKey $address      # Public key input


cat node_info.json
