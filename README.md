# Linux Xbox Controller Fix (EasySMX & Xbox 360 Clones)

This project provides a simple fix for Xbox 360 clone controllers (like **EasySMX ESM-9101**, **8BitDo**, **Mayflash**, etc.) that are not detected on Linux or have blinking LEDs.

## The Problem
Modern Linux drivers like `xone` often **blacklist** the default kernel driver `xpad`. Additionally, generic receivers often get stuck with **"4 blinking LEDs"** and require a physical unplug/replug to be correctly assigned as "Player 1".

## The Solution (v3.0)
The script now performs a **Software-Simulated Physical Re-plug**. It doesn't just reset the USB; it virtually "detaches" and "reattaches" the device via the Linux kernel's USB authorization system.

Key features:
1. **Automatic Blacklist Removal**: Cleans up conflicting configuration files.
2. **Driver Management**: Unloads `xone` and ensures `xpad` is correctly loaded.
3. **Virtual Re-plug**: Simulates a physical unplug/replug by toggling the USB `authorized` state. This forces the system to re-recognize the receiver from scratch.
4. **Player 1 LED Fix**: Automatically forces the controller to the "Player 1" solid LED state.

## How to Use
The fix is integrated into the system and can be triggered manually:
```bash
sudo fix-xbox-controller
```

## Maintenance
The system version is located at `/usr/local/bin/fix-xbox-controller`. You can keep a copy of `fix_xbox_controller.sh` in your project folder for backup.

## Why use Software Re-plug?
Previously, users had to physically remove the USB dongle to fix the blinking LEDs. Version 3.0 automates this process entirely via software, making it ideal for media centers, Steam Deck docks, or any setup where the PC is not easily accessible.
