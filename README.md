# Linux Xbox Controller Fix (EasySMX & Xbox 360 Clones)

This project provides a simple fix for Xbox 360 clone controllers (like **EasySMX ESM-9101**, **8BitDo**, **Mayflash**, etc.) that are not detected on Linux or have blinking LEDs.

## The Problem
Modern Linux drivers like `xone` (used for Xbox One/Series controllers) often **blacklist** the default kernel driver `xpad`. 

While this is fine for original Xbox One controllers, it breaks support for:
- Generic Xbox 360 wireless clones with dedicated USB dongles.
- Older Xbox 360 controllers.
- Devices that emulate the Xbox 360 protocol (X-Input).

When the `xpad` driver is blacklisted, the USB dongle is recognized by the system hardware, but no input device (`/dev/input/jsX`) is created, making it invisible to Steam and games. Additionally, many clones suffer from the **"4 blinking LEDs"** issue if not reset properly.

## The Solution
The provided fix is now **integrated into your system**. It works by:
1. Identifying and removing the blacklist configuration files created by `xone`.
2. Unloading conflicting `xone` modules.
3. Forcing the system to load the correct `xpad` driver.
4. **Automatic LED Fix & USB Reset**: Resets the USB connection via software to fix the blinking LEDs and ensure the controller is correctly initialized as "Player 1".

## How to Use
Since the fix is now integrated into the system, **you don't need to do anything**. It runs automatically at boot or whenever the controller is plugged in.

If you ever need to run it manually:
```bash
sudo fix-xbox-controller
```

## Compatibility
Tested and confirmed working on:
- **EasySMX ESM-9101**
- Generic "GAME FOR WINDOWS" Wireless Receivers
- Arch Linux / CachyOS / Manjaro / Ubuntu

## Why this happens?
Many "gaming" Linux distributions pre-install `xone` or `xpadneo` for better support of newer controllers. However, the `xone` package often includes a file in `/usr/lib/modprobe.d/` or `/etc/modprobe.d/` that explicitly prevents the system from loading the older `xpad` driver to avoid conflicts, unknowingly breaking older/clone hardware. This fix restores the correct driver and uses a software USB reset to simulate a physical unplug/replug, which solves the LED blinking issue.

## Maintenance
You can safely delete any local `fix_xbox_controller.sh` files. The system version is located at `/usr/local/bin/fix-xbox-controller`.
