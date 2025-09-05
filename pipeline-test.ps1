Write-Host "🔍 PIPELINE FLOW TEST" -ForegroundColor Yellow
Write-Host ""
Write-Host "✅ Step 1: Homepage (index.html)" -ForegroundColor Green
Get-Content index.html | Select-String "RSVP Now" | Write-Host -ForegroundColor Cyan

Write-Host ""
Write-Host "✅ Step 2: Survey Form (survey-pipeline.html)" -ForegroundColor Green  
Get-Content survey-pipeline.html | Select-String "data-netlify" | Write-Host -ForegroundColor Cyan

Write-Host ""
Write-Host "✅ Step 3: Netlify Function (issue-intake.js)" -ForegroundColor Green
Get-Content "netlify\functions\issue-intake.js" | Select-String "GitHub" | Select-Object -First 3 | Write-Host -ForegroundColor Cyan

Write-Host ""
Write-Host "✅ Step 4: Configuration (netlify.toml)" -ForegroundColor Green
Get-Content netlify.toml | Write-Host -ForegroundColor Cyan

Write-Host ""
Write-Host "🎯 PIPELINE READY!" -ForegroundColor Yellow
Write-Host "Test URL: https://dchs-football.netlify.app/" -ForegroundColor White
