#!/bin/bash


printf "\n"

printf "\n\n"

# Ask the user for input
read -p "🔢 Enter RAM allocation (in GB, e.g., 8): " RAM
read -p "💾 Enter Disk allocation (in GB, e.g., 500): " DISK
read -p "🔑 Enter your Solana wallet Address: " PUBKEY




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
#sudo ufw status

# Install curl if it's not already installed
sudo apt-get install -y curl


GREEN="\033[0;32m"
RESET="\033[0m"
curl -L -o pop "https://dl.pipecdn.app/v0.2.8/pop"
# Print welcome message
printf "${GREEN}"

printf "${RESET}"

# Check if the "pipega" screen session exists
if screen -list | grep -q "pipega"; then
    echo -e "\n✅  Existing 'pipega' screen session found! Resuming it..."
    screen -r pipega
    exit 0
fi

echo "==========================================================="
echo "🚀  Welcome to the PiPe Network Node Installer 🚀"
echo "==========================================================="
echo ""
echo ""

# Ask for the referral code, but enforce the default one
read -p "➡➡ Enter To Proceed Further: " USER_REFERRAL
REFERRAL_CODE="f5475846a58338ff"  # Your default referral code

# Print the referral code that will actually be used
echo -e "\n✅  Using Referral Code: $REFERRAL_CODE (default enforced)"

# Confirm details
echo -e "\n📌 Configuration Summary:"
echo "   🔢 RAM: ${RAM}GB"
echo "   💾 Disk: ${DISK}GB"
echo "   🔑 PubKey: ${PUBKEY}"

cat node_info.json
