#!/bin/bash

# EasySMX / Xbox Controller Fix Script
# Resolves issues where generic Xbox 360 clone controllers (like ESM-9101) 
# are not detected because of driver blacklisting (e.g., by xone).

echo "--- Xbox Controller Fixer ---"

# 1. Remove blacklists that prevent xpad from loading
echo "[1/3] Removing driver blacklists..."
BLACKLIST_FILES=(
    "/usr/lib/modprobe.d/xone-blacklist.conf"
    "/lib/modprobe.d/xone-blacklist.conf"
    "/etc/modprobe.d/xone-blacklist.conf"
)

for file in "${BLACKLIST_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "Removing $file"
        sudo rm "$file"
    fi
done

# 2. Unload conflicting drivers
echo "[2/3] Unloading conflicting drivers (xone)..."
sudo modprobe -r xone-dongle xone-gip 2>/dev/null

# 3. Load the correct driver (xpad)
echo "[3/3] Loading xpad driver..."
sudo modprobe xpad

echo "-----------------------------------"
echo "Done! Your controller should now be recognized."
echo "Check Steam or run 'jstest /dev/input/js0' to verify."
