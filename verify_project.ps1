# 🎵 Music OS Project Verification Script
# This script verifies the project structure before GitHub push

Write-Host "🔍 Verifying Music OS Project Structure..." -ForegroundColor Green

$errors = @()
$warnings = @()

# Check main structure
Write-Host "`n📁 Checking main directories..." -ForegroundColor Cyan

$requiredDirs = @("docs", "scripts", "config", "apps", "legacy")
foreach ($dir in $requiredDirs) {
    if (Test-Path $dir) {
        Write-Host "✅ $dir/" -ForegroundColor Green
    } else {
        $errors += "Missing required directory: $dir"
        Write-Host "❌ $dir/ (MISSING)" -ForegroundColor Red
    }
}

# Check scripts structure
Write-Host "`n🔧 Checking scripts structure..." -ForegroundColor Cyan

$scriptDirs = @("scripts/arch", "scripts/buildroot")
foreach ($dir in $scriptDirs) {
    if (Test-Path $dir) {
        Write-Host "✅ $dir/" -ForegroundColor Green
        $files = Get-ChildItem $dir -File
        foreach ($file in $files) {
            Write-Host "  📄 $($file.Name)" -ForegroundColor White
        }
    } else {
        $errors += "Missing script directory: $dir"
        Write-Host "❌ $dir/ (MISSING)" -ForegroundColor Red
    }
}

# Check config structure
Write-Host "`n⚙️ Checking config structure..." -ForegroundColor Cyan

$configDirs = @("config/arch", "config/buildroot")
foreach ($dir in $configDirs) {
    if (Test-Path $dir) {
        Write-Host "✅ $dir/" -ForegroundColor Green
        $files = Get-ChildItem $dir -File
        foreach ($file in $files) {
            Write-Host "  📄 $($file.Name)" -ForegroundColor White
        }
    } else {
        $warnings += "Missing config directory: $dir"
        Write-Host "⚠️  $dir/ (MISSING)" -ForegroundColor Yellow
    }
}

# Check apps structure
Write-Host "`n🎵 Checking apps structure..." -ForegroundColor Cyan

if (Test-Path "apps/music_player") {
    Write-Host "✅ apps/music_player/" -ForegroundColor Green
    $files = Get-ChildItem "apps/music_player" -Recurse
    foreach ($file in $files) {
        $relativePath = $file.FullName.Replace((Get-Location).Path + "\", "")
        Write-Host "  📄 $relativePath" -ForegroundColor White
    }
} else {
    $errors += "Missing apps/music_player directory"
    Write-Host "❌ apps/music_player/ (MISSING)" -ForegroundColor Red
}

# Check docs structure
Write-Host "`n📚 Checking docs structure..." -ForegroundColor Cyan

if (Test-Path "docs") {
    Write-Host "✅ docs/" -ForegroundColor Green
    $files = Get-ChildItem "docs" -File
    foreach ($file in $files) {
        Write-Host "  📄 $($file.Name)" -ForegroundColor White
    }
} else {
    $errors += "Missing docs directory"
    Write-Host "❌ docs/ (MISSING)" -ForegroundColor Red
}

# Check legacy structure
Write-Host "`n📦 Checking legacy structure..." -ForegroundColor Cyan

if (Test-Path "legacy") {
    Write-Host "✅ legacy/" -ForegroundColor Green
    $dirs = Get-ChildItem "legacy" -Directory
    foreach ($dir in $dirs) {
        Write-Host "  📁 $($dir.Name)/" -ForegroundColor White
    }
} else {
    $warnings += "Missing legacy directory"
    Write-Host "⚠️  legacy/ (MISSING)" -ForegroundColor Yellow
}

# Check for any remaining old files in root
Write-Host "`n🔍 Checking for unwanted files in root..." -ForegroundColor Cyan

$unwantedFiles = Get-ChildItem -Path "." -File | Where-Object { 
    $_.Name -match "^(ARCH_|README_ARCH|CUSTOM_MUSIC_OS_PROMPT|cleanup|reorganize|verify)" 
}

if ($unwantedFiles.Count -gt 0) {
    Write-Host "⚠️  Found files that might need attention:" -ForegroundColor Yellow
    foreach ($file in $unwantedFiles) {
        Write-Host "  📄 $($file.Name)" -ForegroundColor White
        $warnings += "Consider moving $($file.Name) to appropriate location"
    }
}

# Summary
Write-Host "`n📊 Verification Summary:" -ForegroundColor Cyan

if ($errors.Count -eq 0) {
    Write-Host "✅ No critical errors found!" -ForegroundColor Green
} else {
    Write-Host "❌ Found $($errors.Count) critical error(s):" -ForegroundColor Red
    foreach ($err in $errors) {
        Write-Host "  - $err" -ForegroundColor Red
    }
}

if ($warnings.Count -gt 0) {
    Write-Host "`n⚠️  Found $($warnings.Count) warning(s):" -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host "  - $warning" -ForegroundColor Yellow
    }
}

# GitHub readiness
Write-Host "`n🚀 GitHub Readiness Check:" -ForegroundColor Cyan

if ($errors.Count -eq 0) {
    Write-Host "✅ Project is ready for GitHub!" -ForegroundColor Green
    Write-Host "`n📋 Next steps:" -ForegroundColor Yellow
    Write-Host "1. Initialize git repository (if not already done)" -ForegroundColor White
    Write-Host "2. Add all files to git" -ForegroundColor White
    Write-Host "3. Create initial commit" -ForegroundColor White
    Write-Host "4. Push to GitHub" -ForegroundColor White
    Write-Host "5. Start setup with: ./scripts/arch/quick_start.sh" -ForegroundColor White
} else {
    Write-Host "❌ Fix errors before pushing to GitHub" -ForegroundColor Red
}

Write-Host "`n🎵 Verification complete!" -ForegroundColor Green 