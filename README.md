# ⚡ PowerShell Scripts

This repository contains a personal collection of PowerShell utilities designed to automate and troubleshoot system-level tasks on Windows 11. Each script is tailored for reliability, clarity, and ease of use, with a focus on solving real-world issues encountered during daily system operation.

---
### ⚠️ Execution Policy Warning

🚫 Do not globally disable PowerShell’s execution policy (e.g., by setting it to `Unrestricted` or `Bypass` system-wide). Doing so can expose your system to malicious scripts and unintended changes. Instead, use the `-ExecutionPolicy Bypass` flag only when launching trusted scripts, and preferably within a controlled `.bat` file as shown below.

🛡️ Recommended safety practices:

- ⚠️🔍 Always inspect scripts before running them, especially if downloaded from the internet  
- ⚠️🔐 Run scripts with elevated permissions only when necessary  
- ⚠️⚙️ Use `-ExecutionPolicy Bypass` only for specific, trusted scripts—not as a permanent system setting  
- ⚠️🧼 Keep your system and antivirus software up to date  
- ⚠️🧪 Consider using `-WhatIf` or `-TestMode` switches when available to preview script behavior  
---

## 📌 Included Scripts

### 1. 🛠️ Intel Ethernet Controller I225-V Recovery Utility

📄 File: Intel_Ethernet_Controller_I225_V_Recovery.ps1  
🎯 Purpose: Recovers and re-enables the Intel I225-V Ethernet adapter when it becomes disabled or unresponsive.

#### 🔧 Features

- ✅ Detects the adapter status and attempts recovery if disabled  
- 🧰 Disables power management settings in the registry to prevent future dropouts  
- 🛑 Handles protected registry keys gracefully to avoid script failure  
- 📝 Logs all actions and outcomes to a file on the desktop  
- 🧪 Includes a `-TestMode` switch for safe dry runs  
- 📊 Displays a clean summary and exits automatically after user confirmation  

#### 🚀 How to Run

To bypass PowerShell’s execution policy restrictions only for this script, it is launched via a `.bat` file with elevated permissions. This `.bat` file is not included in the repository, but you can create one using the following template:
```batch
@echo off  
set scriptPath=%USERPROFILE%\Powershell_Scripts\Intel_Ethernet_Controller_I225_V_Recovery.ps1  
powershell -Command "Start-Process powershell -ArgumentList '-NoExit -ExecutionPolicy Bypass -File \"%scriptPath%\"' -Verb RunAs"
```
To run the script in test mode (no changes made), modify the `.bat` file like so:
```batch
@echo off  
set scriptPath=%USERPROFILE%\Powershell_Scripts\Intel_Ethernet_Controller_I225_V_Recovery.ps1  
powershell -Command "Start-Process powershell -ArgumentList '-NoExit -ExecutionPolicy Bypass -File \"%scriptPath%\" -TestMode' -Verb RunAs"
```
📌 Note: The `.bat` file assumes the PowerShell script is stored in `%USERPROFILE%\Powershell_Scripts\`

#### 📁 Log File

A log file named `AdapterRecoveryLog.txt` is created on the user's desktop, recording each recovery attempt with timestamps and status updates.

---

### 2. 🌐 Open Microsoft Edge in Fullscreen

📄 File: open_ms_edge_in_fullscreen.ps1  
🎯 Purpose: Automatically launches Microsoft Edge in fullscreen mode, intended for use with a local Ping Monitor application.

#### 🔧 Features

- ⏱️ Waits for system startup and Ping Monitor initialization  
- 🌍 Opens Edge to a specified local URL  
- 🎹 Simulates an F11 keypress to enter fullscreen mode  
- 🧩 Uses .NET interop to trigger the fullscreen shortcut  

This script is ideal for kiosk-style setups or monitoring dashboards that require a clean, fullscreen browser view.

---

## 🧰 Notes

- 🪟 All scripts are designed to run on Windows 11 with administrative privileges  
- 🧾 Scripts are documented with inline comments for clarity and customization  
- 🧭 The `.bat` launcher for the Ethernet recovery script is referenced for convenience but not included in the repository  

---

💡 Feel free to fork, adapt, or extend these tools for your own use. Contributions and suggestions are welcome!