# Define your adapter name (change if needed)
$adapterName = "Ethernet"

Write-Host "🔍 Checking status of adapter '$adapterName'..." -ForegroundColor Cyan
$adapter = Get-NetAdapter -Name $adapterName -ErrorAction SilentlyContinue

if (!$adapter) {
    Write-Host "❌ Adapter '$adapterName' not found." -ForegroundColor Red
    exit
}

if ($adapter.Status -eq "Disabled") {
    Write-Host "⚠️ Adapter is currently DISABLED. Attempting recovery..." -ForegroundColor Yellow

    # Disable power management (optional but recommended)
    $device = Get-PnpDevice | Where-Object { $_.FriendlyName -like "*I225-V*" }
    if ($device) {
        $deviceId = $device.InstanceId
        Write-Host "🔧 Disabling power management for device: $deviceId" -ForegroundColor Cyan
        $regPath = "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}"
        $keys = Get-ChildItem $regPath
        foreach ($key in $keys) {
            $pmSetting = Get-ItemProperty "$regPath\$($key.PSChildName)" -ErrorAction SilentlyContinue
            if ($pmSetting.DriverDesc -like "*I225-V*") {
                Set-ItemProperty "$regPath\$($key.PSChildName)" "PnPCapabilities" 24
                Write-Host "✅ Power management disabled in registry." -ForegroundColor Green
            }
        }
    }

    # Try disabling and enabling the adapter
    Disable-NetAdapter -Name $adapterName -Confirm:$false
    Start-Sleep -Seconds 3
    Enable-NetAdapter -Name $adapterName -Confirm:$false
    Start-Sleep -Seconds 5

    # Recheck status
    $adapter = Get-NetAdapter -Name $adapterName
    if ($adapter.Status -eq "Up") {
        Write-Host "✅ Adapter successfully re-enabled!" -ForegroundColor Green
    } else {
        Write-Host "❌ Recovery failed. Adapter still disabled." -ForegroundColor Red
    }
} else {
    Write-Host "✅ Adapter is already ENABLED and working." -ForegroundColor Green
}