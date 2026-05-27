#!/bin/bash

# EasySMX / Xbox Controller Fix Script v3.0
# Resolves driver issues and simulates physical unplug/replug via software.

echo "--- Xbox Controller Fixer v3.0 ---"

# 1. Driver Management
echo "[1/3] Managing drivers..."
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

# Reload xpad driver to ensure it's clean
echo "Reloading xpad driver..."
sudo modprobe -r xpad 2>/dev/null
sudo modprobe -r xone-dongle xone-gip 2>/dev/null
sudo modprobe xpad

# 2. USB Reset (Simulated Physical Re-plug)
echo "[2/3] Simulating physical unplug/replug for Xbox controller..."
FOUND=false
# Loop through USB devices to find the Xbox 360 controller receiver (045e:028e)
for dev in /sys/bus/usb/devices/*; do
    if [ -f "$dev/idVendor" ] && [ -f "$dev/idProduct" ]; then
        v=$(cat "$dev/idVendor" 2>/dev/null)
        p=$(cat "$dev/idProduct" 2>/dev/null)
        if [ "$v" == "045e" ] && [ "$p" == "028e" ]; then
            echo "Found controller receiver at $dev. Performing virtual replug..."
            if [ -f "$dev/authorized" ]; then
                # De-authorize the device (simulates unplug)
                echo 0 | sudo tee "$dev/authorized" > /dev/null
                sleep 1
                # Re-authorize the device (simulates replug)
                echo 1 | sudo tee "$dev/authorized" > /dev/null
                FOUND=true
            else
                # Fallback to usbreset if 'authorized' is not available
                if command -v usbreset >/dev/null 2>&1; then
                    echo "Using usbreset as fallback..."
                    sudo usbreset "$v:$p"
                    FOUND=true
                fi
            fi
            sleep 2
        fi
    fi
done

if [ "$FOUND" = false ]; then
    echo "No Xbox 360 controller receiver (045e:028e) detected."
fi

# 3. Force LED 1 to be solid (Player 1)
echo "[3/3] Setting LED status to Player 1..."
# Wait a bit for the device to re-initialize after replug
sleep 1
for led in /sys/class/leds/xpad*/brightness; do
    if [ -f "$led" ]; then
        echo "Setting $led to 6 (Player 1)..."
        echo 6 | sudo tee "$led" > /dev/null
    fi
done

echo "-----------------------------------"
echo "Done! The controller has been 'virtually' replugged."
echo "Check Steam or run 'jstest /dev/input/js0' to verify."
