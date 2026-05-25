#!/bin/bash

# EasySMX / Xbox Controller Fix Script.
# Resolves issues where generic Xbox 360 clone controllers (like ESM-9101) 
# are not detected because of driver blacklisting (e.g., by xone)
# AND fixes the "4 blinking LEDs" issue via software USB reset.

echo "--- Xbox Controller Fixer v2.0 ---"

# 1. Remove blacklists that prevent xpad from loading
echo "[1/3] Removing driver blacklists & managing modules..."
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

# Unload conflicting drivers and load xpad
sudo modprobe -r xone-dongle xone-gip 2>/dev/null
sudo modprobe xpad

# 2. USB Reset to fix blinking LEDs
# This simulates physical unplug/replug if captured by usbfs (Steam conflict)
echo "[2/3] Performing USB reset to fix LED blinking..."
for dev in /sys/bus/usb/devices/*; do
    if [ -f "$dev/idVendor" ] && [ "$(cat $dev/idVendor 2>/dev/null)" == "045e" ] && [ "$(cat $dev/idProduct 2>/dev/null)" == "028e" ]; then
        if [ -L "$dev:1.0/driver" ]; then
            driver=$(basename $(readlink "$dev:1.0/driver"))
            if [ "$driver" == "usbfs" ]; then
                echo "Resetting controller on $dev..."
                sudo usbreset 045e:028e
                sleep 2
            fi
        fi
    fi
done

# 3. Force LED 1 to be solid (Player 1)
echo "[3/3] Setting LED status..."
for led in /sys/class/leds/xpad*/brightness; do
    if [ -f "$led" ]; then
        echo 6 | sudo tee "$led" > /dev/null
    fi
done

echo "-----------------------------------"
echo "Done! Your controller should now be recognized and LEDs fixed."
echo "Check Steam or run 'jstest /dev/input/js0' to verify."
