# Toxic Tracker Web Test Script
# Encoding: UTF-8

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Toxic Tracker - Web Browser Test" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Set Flutter environment variables
$env:PATH = "E:\works\flutter_sdk\flutter\bin;$env:PATH"
$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"

Write-Host "[1/3] Checking Flutter environment..." -ForegroundColor Yellow
flutter --version
Write-Host ""

Write-Host "[2/3] Installing dependencies..." -ForegroundColor Yellow
Write-Host "First run may take 5-10 minutes, please wait..." -ForegroundColor Gray
flutter pub get
Write-Host ""

Write-Host "[3/3] Starting web server..." -ForegroundColor Yellow
Write-Host "Browser will open automatically" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Gray
Write-Host ""
flutter run -d chrome

Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
