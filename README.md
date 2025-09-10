# ⚡ Powershell_Scripts

A personal repository for managing useful PowerShell scripts. These scripts are designed to automate tasks, configure systems, and streamline workflows on Windows environments.

## 📁 Repository Contents

- `open_ms_edge_in_fullscreen.ps1`  
  Launches Microsoft Edge in fullscreen mode. Ideal for kiosk setups or distraction-free browsing.

- `Intel_Ethernet_Controller_I225_V_Recovery.ps1`  
  Detects if the Intel I225-V Ethernet adapter is disabled and attempts recovery without requiring a system reboot. The script disables power management settings, toggles the adapter state, and provides real-time status updates. Useful for resolving intermittent network drops on systems using the I225-V controller.

## 🚀 Usage

1. Clone the repository:  
   git clone https://github.com/SilentWoof/Powershell_Scripts.git

2. Navigate to the desired script:  
   cd Powershell_Scripts

3. Run the script in PowerShell:  
   .\script_name.ps1

**Note:** If your system blocks script execution due to policy restrictions, you can temporarily bypass it with:  
powershell -ExecutionPolicy Bypass -File /path/to/script.ps1

⚠️ **Security Warning:**  
Using `-ExecutionPolicy Bypass` disables important safety checks. **Only do this if you fully understand what the script does and trust its source. Never run unverified scripts—especially those downloaded from the internet—as they may contain malicious code.**

🔒 **Administrator Privileges:**  
Some scripts may require elevated permissions. If prompted, right-click PowerShell and select “Run as Administrator.”

**IMPORTANT:** Running scripts as Administrator gives them full access to your system. Always inspect the script’s contents before executing. If you're unsure what it does, seek expert advice or run it in a safe, isolated environment first.

## 📜 License

This project is licensed under the MIT License. See the LICENSE file for details.

## 🙌 Contributions

This is a personal utility repository, but suggestions and improvements are welcome via pull requests or issues.

---

Made with ⚙️ and 🧠 by SilentWoof  
GitHub: https://github.com/SilentWoof