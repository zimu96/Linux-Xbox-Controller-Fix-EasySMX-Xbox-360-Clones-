# Linux Xbox Controller Fix (EasySMX & Xbox 360 Clones)

This project provides a simple fix for Xbox 360 clone controllers (like **EasySMX ESM-9101**, **8BitDo**, **Mayflash**, etc.) that are not detected on Linux.

## The Problem
Modern Linux drivers like `xone` (used for Xbox One/Series controllers) often **blacklist** the default kernel driver `xpad`. 

While this is fine for original Xbox One controllers, it breaks support for:
- Generic Xbox 360 wireless clones with dedicated USB dongles.
- Older Xbox 360 controllers.
- Devices that emulate the Xbox 360 protocol (X-Input).

When the `xpad` driver is blacklisted, the USB dongle is recognized by the system hardware, but no input device (`/dev/input/jsX`) is created, making it invisible to Steam and games.

## The Solution
The provided script fixes this by:
1. Identifying and removing the blacklist configuration files created by `xone`.
2. Unloading conflicting `xone` modules.
3. Forcing the system to load the correct `xpad` driver.

## How to Use
1. Clone this repository or download the `fix_xbox_controller.sh` script.
2. Make the script executable:
   ```bash
   chmod +x fix_xbox_controller.sh
   ```
3. Run the script:
   ```bash
   ./fix_xbox_controller.sh
   ```

## Compatibility
Tested and confirmed working on:
- **EasySMX ESM-9101**
- Generic "GAME FOR WINDOWS" Wireless Receivers
- Arch Linux / CachyOS / Manjaro / Ubuntu

## Why this happens?
Many "gaming" Linux distributions pre-install `xone` or `xpadneo` for better support of newer controllers. However, the `xone` package often includes a file in `/usr/lib/modprobe.d/` or `/etc/modprobe.d/` that explicitly prevents the system from loading the older `xpad` driver to avoid conflicts, unknowingly breaking older/clone hardware.
