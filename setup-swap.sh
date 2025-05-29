#!/bin/bash

# Check if swap exists
if free | grep -q 'Swap'; then
    echo "Swap already exists. Current swap configuration:"
    swapon --show
    free -h
    exit 0
fi

# Create and configure swap
echo "Setting up swap space..."
sudo fallocate -l 1.5G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Make swap permanent
if ! grep -q '/swapfile' /etc/fstab; then
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi

# Optimize swap settings
echo "Optimizing swap settings..."
# Set swappiness to a lower value (default is 60)
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
# Increase cache pressure to improve memory management
echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Show results
echo "Swap setup complete. Current memory configuration:"
free -h
echo -e "\nSwap configuration:"
swapon --show
echo -e "\nSwap settings:"
cat /proc/sys/vm/swappiness
echo "Done! The system will use this swap space even after reboot."
