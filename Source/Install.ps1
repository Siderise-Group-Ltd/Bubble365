$msiFile = "Bubble-win-x64-3.58.0.msi"
$arguments = "/i `"$msiFile`" /qn /norestart"

try {
    Write-Host "Installing $msiFile..."
    $process = Start-Process -FilePath "msiexec.exe" -ArgumentList $arguments -Wait -PassThru -NoNewWindow
    $exitCode = $process.ExitCode
    Write-Host "Installation exited with code: $exitCode"
    exit $exitCode
} catch {
    Write-Error "Failed to install $msiFile. Error: $_"
    exit 1
}
