Write-Host "========================================" -ForegroundColor Cyan
Write-Host "今天鸽了吗 - Web 浏览器测试" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 设置 Flutter 环境变量
$env:PATH = "E:\works\flutter_sdk\flutter\bin;$env:PATH"
$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"

Write-Host "[1/3] 检查 Flutter 环境..." -ForegroundColor Yellow
flutter --version
Write-Host ""

Write-Host "[2/3] 安装项目依赖..." -ForegroundColor Yellow
Write-Host "首次运行可能需要 5-10 分钟，请耐心等待..." -ForegroundColor Gray
flutter pub get
Write-Host ""

Write-Host "[3/3] 启动 Web 服务器..." -ForegroundColor Yellow
Write-Host "浏览器将自动打开应用" -ForegroundColor Green
Write-Host "按 Ctrl+C 可以停止服务器" -ForegroundColor Gray
Write-Host ""
flutter run -d chrome

Write-Host ""
Write-Host "按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
