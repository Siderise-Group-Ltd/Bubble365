$targetVersion = "3.58.0"
$productCode = "{CDB260E0-F567-4C23-80A2-92BAEC6DC92C}"

try {
    # Check registry for the product code
    $uninstallKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$productCode"
    $uninstallKeyWow6432 = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\$productCode"
    
    $installedVersion = $null

    if (Test-Path $uninstallKey) {
        $installedVersion = (Get-ItemProperty -Path $uninstallKey -Name "DisplayVersion" -ErrorAction SilentlyContinue).DisplayVersion
    } elseif (Test-Path $uninstallKeyWow6432) {
        $installedVersion = (Get-ItemProperty -Path $uninstallKeyWow6432 -Name "DisplayVersion" -ErrorAction SilentlyContinue).DisplayVersion
    }

    if ($installedVersion) {
        # Compare versions
        if ([version]$installedVersion -ge [version]$targetVersion) {
            Write-Host "Detected installed version $installedVersion which is greater than or equal to required version $targetVersion"
            exit 0 # Found
        } else {
            Write-Host "Detected installed version $installedVersion which is less than required version $targetVersion"
            exit 1 # Not found / Needs update
        }
    } else {
        # Check WMI as fallback
        $app = Get-WmiObject -Class Win32_Product | Where-Object { $_.IdentifyingNumber -eq $productCode }
        if ($app) {
            if ([version]$app.Version -ge [version]$targetVersion) {
                Write-Host "Detected installed version $($app.Version) via WMI which is greater than or equal to required version $targetVersion"
                exit 0 # Found
            } else {
                Write-Host "Detected installed version $($app.Version) via WMI which is less than required version $targetVersion"
                exit 1 # Not found / Needs update
            }
        }
        
        Write-Host "Application with Product Code $productCode not found."
        exit 1 # Not found
    }
} catch {
    Write-Error "Error during detection: $_"
    exit 1 # Not found / Error
}
