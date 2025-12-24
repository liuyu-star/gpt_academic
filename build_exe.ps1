# Build script for Windows (PowerShell)
# Usage: Right-click -> "Run with PowerShell" or run in an elevated PowerShell

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

$venvPath = Join-Path $scriptDir 'venv_build'
if (-not (Test-Path $venvPath)) {
    Write-Host "Creating virtualenv at $venvPath..."
    python -m venv $venvPath
}

Write-Host "Activating venv and installing dependencies..."
& "$venvPath\Scripts\pip.exe" install --upgrade pip
if (Test-Path "$scriptDir\requirements.txt") {
    & "$venvPath\Scripts\pip.exe" install -r "$scriptDir\requirements.txt"
}
& "$venvPath\Scripts\pip.exe" install pyinstaller

# Build with PyInstaller. Adjust options as needed (--onefile, --noconsole, --add-data, etc.)
Write-Host "Running PyInstaller... this may take a few minutes."
# Get the path to gradio_client in the venv to include types.json
$gradioClientPath = & "$venvPath\Scripts\python.exe" -c "import gradio_client; import os; print(os.path.dirname(gradio_client.__file__))" 2>$null
if ($gradioClientPath) {
    Write-Host "Including gradio_client data from: $gradioClientPath"
    & "$venvPath\Scripts\pyinstaller.exe" --noconfirm --clean --onefile --name gpt_academic `
        --hidden-import=gradio_client.types `
        --add-data "$gradioClientPath;gradio_client" `
        main.py
} else {
    Write-Host "Could not locate gradio_client, proceeding with standard PyInstaller options..."
    & "$venvPath\Scripts\pyinstaller.exe" --noconfirm --clean --onefile --name gpt_academic `
        --hidden-import=gradio_client.types `
        main.py
}

if (Test-Path "$scriptDir\dist\gpt_academic.exe") {
    Write-Host "Build succeeded: $scriptDir\dist\gpt_academic.exe"
} else {
    Write-Host "Build completed but executable not found. Check PyInstaller output above for errors." -ForegroundColor Yellow
}

Write-Host "Notes:"
Write-Host "- If your app needs additional data files or folders, add: --add-data 'source;dest' (use ';' on Windows)."
Write-Host "- If modules are missing at runtime, use --hidden-import modulename or add them in a spec file."
Write-Host "- For GUI apps, remove --noconsole to see stdout/stderr during run."
