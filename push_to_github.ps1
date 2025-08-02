# 🎵 Music OS GitHub Push Script
# This script helps push the project to GitHub

Write-Host "🚀 Preparing to push Music OS to GitHub..." -ForegroundColor Green

# Check if git is initialized
if (!(Test-Path ".git")) {
    Write-Host "`n📦 Initializing git repository..." -ForegroundColor Cyan
    git init
    Write-Host "✅ Git repository initialized" -ForegroundColor Green
} else {
    Write-Host "✅ Git repository already exists" -ForegroundColor Green
}

# Create .gitignore file
Write-Host "`n📝 Creating .gitignore file..." -ForegroundColor Cyan

$gitignore = @"
# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE files
.vscode/
.idea/
*.swp
*.swo
*~

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual environments
venv/
env/
ENV/

# Logs
*.log
logs/

# Temporary files
*.tmp
*.temp
temp/
tmp/

# Build artifacts
*.iso
*.img
*.tar.gz
*.zip

# Music files (for testing)
*.mp3
*.flac
*.wav
*.m4a
*.aac
*.ogg

# Configuration files with sensitive data
config/arch/wpa_supplicant.conf
config/arch/spotify.conf
config/arch/ssh_keys/

# System files
*.pid
*.lock
"@

Set-Content ".gitignore" $gitignore
Write-Host "✅ .gitignore created" -ForegroundColor Green

# Add all files to git
Write-Host "`n📦 Adding files to git..." -ForegroundColor Cyan
git add .

# Check git status
Write-Host "`n📊 Git status:" -ForegroundColor Cyan
git status

# Create initial commit
Write-Host "`n💾 Creating initial commit..." -ForegroundColor Cyan
git commit -m "🎵 Initial commit: Music OS project

- Arch Linux and Buildroot versions
- Complete documentation
- Setup scripts for both versions
- Music player application
- Configuration files
- Legacy files preserved

Ready for development!"

Write-Host "✅ Initial commit created" -ForegroundColor Green

# Instructions for GitHub
Write-Host "`n🚀 Ready to push to GitHub!" -ForegroundColor Green
Write-Host "`n📋 Next steps:" -ForegroundColor Yellow
Write-Host "1. Create a new repository on GitHub:" -ForegroundColor White
Write-Host "   - Go to https://github.com/new" -ForegroundColor White
Write-Host "   - Name it 'music-os' or 'musiceOS'" -ForegroundColor White
Write-Host "   - Make it public or private as you prefer" -ForegroundColor White
Write-Host "   - Don't initialize with README (we already have one)" -ForegroundColor White
Write-Host "`n2. Add the remote and push:" -ForegroundColor White
Write-Host "   git remote add origin https://github.com/YOUR_USERNAME/music-os.git" -ForegroundColor Cyan
Write-Host "   git branch -M main" -ForegroundColor Cyan
Write-Host "   git push -u origin main" -ForegroundColor Cyan
Write-Host "`n3. Start the setup:" -ForegroundColor White
Write-Host "   ./scripts/arch/quick_start.sh" -ForegroundColor Cyan

Write-Host "`n🎵 Your Music OS project is ready for GitHub!" -ForegroundColor Green 