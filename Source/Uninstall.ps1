$msiFile = "Bubble-win-x64-3.58.0.msi"
$arguments = "/x `"$msiFile`" /qn /norestart"

try {
    Write-Host "Uninstalling $msiFile..."
    $process = Start-Process -FilePath "msiexec.exe" -ArgumentList $arguments -Wait -PassThru -NoNewWindow
    $exitCode = $process.ExitCode
    Write-Host "Uninstallation exited with code: $exitCode"
    exit $exitCode
} catch {
    Write-Error "Failed to uninstall $msiFile. Error: $_"
    exit 1
}
