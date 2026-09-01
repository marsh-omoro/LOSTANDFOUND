#!/usr/bin/env powershell
# Lost & Found System - Local Verification Checklist

Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   Lost & Found System - Local Verification Guide          ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Green

# ============================================================================
# STEP 1: Check Apache Status
# ============================================================================
Write-Host "✓ STEP 1: Checking Apache Server Status..." -ForegroundColor Yellow

$apache = Get-Process httpd -ErrorAction SilentlyContinue
if ($apache) {
    Write-Host "   ✅ Apache is RUNNING (PID: $($apache[0].Id))" -ForegroundColor Green
} else {
    Write-Host "   ❌ Apache is NOT running" -ForegroundColor Red
    Write-Host "   → Start XAMPP and enable Apache in the control panel" -ForegroundColor Yellow
}

# ============================================================================
# STEP 2: Check MySQL Status
# ============================================================================
Write-Host "`n✓ STEP 2: Checking MySQL Database Status..." -ForegroundColor Yellow

$mysql = Get-Process mysqld -ErrorAction SilentlyContinue
if ($mysql) {
    Write-Host "   ✅ MySQL is RUNNING (PID: $($mysql[0].Id))" -ForegroundColor Green
} else {
    Write-Host "   ❌ MySQL is NOT running" -ForegroundColor Red
    Write-Host "   → Start XAMPP and enable MySQL in the control panel" -ForegroundColor Yellow
}

# ============================================================================
# STEP 3: Check Application Directory
# ============================================================================
Write-Host "`n✓ STEP 3: Checking Application Directory..." -ForegroundColor Yellow

$appPath = "C:\xampp\htdocs\LOSTANDFOUND"
if (Test-Path $appPath) {
    Write-Host "   ✅ Application found at: $appPath" -ForegroundColor Green
    
    $indexExists = Test-Path "$appPath\index.php"
    if ($indexExists) {
        Write-Host "   ✅ index.php exists" -ForegroundColor Green
    }
} else {
    Write-Host "   ❌ Application directory not found" -ForegroundColor Red
}

# ============================================================================
# STEP 4: Check Configuration Files
# ============================================================================
Write-Host "`n✓ STEP 4: Checking Configuration Files..." -ForegroundColor Yellow

$envFile = "$appPath\.env"
$envExample = "$appPath\.env.example"

if (Test-Path $envFile) {
    Write-Host "   ✅ .env file exists" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  .env file NOT found" -ForegroundColor Yellow
    Write-Host "   → Create it: cp .env.example .env" -ForegroundColor Yellow
}

if (Test-Path $envExample) {
    Write-Host "   ✅ .env.example exists" -ForegroundColor Green
}

# ============================================================================
# STEP 5: Check Helper Classes
# ============================================================================
Write-Host "`n✓ STEP 5: Checking Helper Classes..." -ForegroundColor Yellow

$files = @(
    "config/bootstrap.php",
    "config/EnvLoader.php",
    "config/Validator.php",
    "config/CSRFToken.php",
    "config/Logger.php"
)

foreach ($file in $files) {
    $path = "$appPath\$file"
    if (Test-Path $path) {
        Write-Host "   ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $file NOT found" -ForegroundColor Red
    }
}

# ============================================================================
# STEP 6: Verify Logs Directory
# ============================================================================
Write-Host "`n✓ STEP 6: Checking Logs Directory..." -ForegroundColor Yellow

$logsDir = "$appPath\logs"
if (Test-Path $logsDir) {
    Write-Host "   ✅ Logs directory exists" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Logs directory NOT found" -ForegroundColor Yellow
    Write-Host "   → Create it: mkdir logs" -ForegroundColor Yellow
}

# ============================================================================
# STEP 7: Summary & Next Steps
# ============================================================================
Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                    VERIFICATION COMPLETE                  ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Green

Write-Host "🌐 ACCESS YOUR APPLICATION:" -ForegroundColor Cyan
Write-Host "   URL: http://localhost/LOSTANDFOUND" -ForegroundColor White
Write-Host "   Open in your browser ↑" -ForegroundColor Cyan

Write-Host "`n📋 WHAT TO TEST:" -ForegroundColor Cyan
Write-Host "   1. ✓ See login/register page" -ForegroundColor White
Write-Host "   2. ✓ Try creating an account" -ForegroundColor White
Write-Host "   3. ✓ Try logging in" -ForegroundColor White
Write-Host "   4. ✓ Check for error messages" -ForegroundColor White

Write-Host "`n📊 CHECK LOGS FOR ERRORS:" -ForegroundColor Cyan
Write-Host "   Location: $logsDir" -ForegroundColor White

Write-Host "`n⚙️  IF SOMETHING DOESN'T WORK:" -ForegroundColor Cyan
Write-Host "   1. Check XAMPP Apache & MySQL are running" -ForegroundColor White
Write-Host "   2. Check if .env file exists" -ForegroundColor White
Write-Host "   3. Check database credentials in .env" -ForegroundColor White
Write-Host "   4. Check browser console (F12) for errors" -ForegroundColor White
Write-Host "   5. Check logs/ directory for error logs" -ForegroundColor White

Write-Host "`n✨ Happy Testing! 🚀`n" -ForegroundColor Green
