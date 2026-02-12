# ISP-Watchdog: Internal Network Connectivity Logger
# This script monitors the connection between the PC and the Router (Gateway).

# --- Configuration ---
$TargetIP = "192.168.178.1"  # Your Router/Gateway IP
$LogFile = "$env:USERPROFILE\Desktop\Internal_Ping_Log.csv"
$IntervalSeconds = 1

# Create CSV Header if file doesn't exist
if (-not (Test-Path $LogFile)) {
    "Timestamp;Target;Status;Latency_ms" | Out-File $LogFile -Encoding utf8
}

Write-Host "Internal Monitoring started... Target: $TargetIP" -ForegroundColor Cyan
Write-Host "Logs are being saved to: $LogFile" -ForegroundColor Gray
Write-Host "Press CTRL+C to stop." -ForegroundColor Yellow

# --- Monitoring Loop ---
while ($true) {
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    try {
        # Perform a single ping test
        $Ping = Test-Connection -ComputerName $TargetIP -Count 1 -ErrorAction Stop
        $Latency = $Ping.ResponseTime
        $Status = "OK"
        $Color = "Green"
        
        # Highlight latency spikes above 10ms (unusual for wired LAN)
        if ($Latency -gt 10) { $Color = "Yellow" }
    }
    catch {
        $Status = "TIMEOUT"
        $Latency = "0"
        $Color = "Red"
    }

    # Console Output
    Write-Host "[$Timestamp] Status: $Status | Latency: $($Latency)ms" -ForegroundColor $Color

    # Save to CSV
    "$Timestamp;$TargetIP;$Status;$Latency" | Out-File $LogFile -Append -Encoding utf8

    Start-Sleep -Seconds $IntervalSeconds
}