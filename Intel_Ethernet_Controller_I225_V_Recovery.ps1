param (
    [switch]$TestMode
)

# Version tag
$scriptVersion = "1.1.0"

# Log file path
$logFile = "$env:USERPROFILE\Desktop\AdapterRecoveryLog.txt"

# Adapter name
$adapterName = "Ethernet"

# Header
Write-Host "`n========================================="
Write-Host " Intel I225-V Recovery Utility - v$scriptVersion"
Write-Host "=========================================`n"

Add-Content $logFile "`n[$(Get-Date)] Starting recovery for adapter '$adapterName' (Version $scriptVersion)"

# Check adapter status
Write-Host "Checking status of adapter '$adapterName'..."
$adapter = Get-NetAdapter -Name $adapterName -ErrorAction SilentlyContinue

if (!$adapter) {
    Write-Host "❌ Adapter '$adapterName' not found."
    Add-Content $logFile "[$(Get-Date)] Adapter not found."
    Read-Host -Prompt "Press Enter to close this window"
    Stop-Process -Id $PID
}

if ($adapter.Status -eq "Disabled") {
    Write-Host "⚠️ Adapter is currently DISABLED. Attempting recovery..."
    Add-Content $logFile "[$(Get-Date)] Adapter status: Disabled"

    # Disable power management
    $devices = Get-PnpDevice | Where-Object { $_.FriendlyName -like "*I225-V*" }
    foreach ($device in $devices) {
        $deviceId = $device.InstanceId
        Write-Host "Disabling power management for device: $deviceId"
        Add-Content $logFile "[$(Get-Date)] Found device: $deviceId"

        $regPath = "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}"
        $keys = Get-ChildItem $regPath -ErrorAction SilentlyContinue

        foreach ($key in $keys) {
            try {
                $pmSetting = Get-ItemProperty "$($key.PSPath)" -ErrorAction Stop
                if ($pmSetting.DriverDesc -like "*I225-V*") {
                    if (-not $TestMode) {
                        Set-ItemProperty "$($key.PSPath)" "PnPCapabilities" 24
                    }
                    Write-Host "Power management disabled in registry."
                    Add-Content $logFile "[$(Get-Date)] Registry updated for key: $($key.Name)"
                }
            } catch {
                Write-Host "⚠️ Skipped inaccessible key: $($key.Name)"
                Add-Content $logFile "[$(Get-Date)] Skipped inaccessible key: $($key.Name)"
            }
        }
    }

    # Adapter recovery
    if (-not $TestMode) {
        try {
            Disable-NetAdapter -Name $adapterName -Confirm:$false
            Start-Sleep -Seconds 3
            Enable-NetAdapter -Name $adapterName -Confirm:$false
            Start-Sleep -Seconds 5
        } catch {
            Write-Host "❌ Failed to disable/enable adapter: $_"
            Add-Content $logFile "[$(Get-Date)] Adapter recovery failed: $_"
        }
    } else {
        Write-Host "Test mode: Skipping adapter disable/enable."
        Add-Content $logFile "[$(Get-Date)] Test mode: Adapter not modified."
    }

    # Recheck status
    $adapter = Get-NetAdapter -Name $adapterName
    if ($adapter.Status -eq "Up") {
        Write-Host "✅ Adapter successfully re-enabled!"
        Add-Content $logFile "[$(Get-Date)] Adapter successfully re-enabled."
    } else {
        Write-Host "❌ Recovery failed. Adapter still disabled."
        Add-Content $logFile "[$(Get-Date)] Recovery failed. Adapter still disabled."
    }
} else {
    Write-Host "✅ Adapter is already ENABLED and working."
    Add-Content $logFile "[$(Get-Date)] Adapter already enabled."
}

# Summary
Write-Host "`n========================================="
Write-Host "           Recovery Summary"
Write-Host "========================================="
Write-Host "Adapter: $adapterName"
Write-Host "Status after recovery: $($adapter.Status)"
Write-Host "Power management registry updated: Yes"
Write-Host "Log saved to: $logFile"

# Footer and exit
Read-Host -Prompt "`nPress Enter to close this window"
Stop-Process -Id $PID