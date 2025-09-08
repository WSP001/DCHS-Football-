# Force the exact good state, deploy, and verify immediately
(Get-Content survey-complete.html) -replace 'action="/thank-you/?[^"]*"', 'action="/thank-you.html"' |
  Set-Content survey-complete.html

# Ensure thank-you.html exists (the main file)
if (!(Test-Path thank-you.html)) {
  Write-Host "Creating thank-you.html from thank-you/index.html"
  Copy-Item thank-you/index.html thank-you.html -Force
}

# Ensure thank-you/index.html exists as backup
if (!(Test-Path thank-you/index.html)) {
  New-Item -ItemType Directory thank-you -Force | Out-Null
  Copy-Item thank-you.html thank-you/index.html -Force
}

git add survey-complete.html thank-you.html thank-you/index.html netlify.toml
git commit -m "fix(forms): lock action to /thank-you.html and ensure bulletproof routing" -ErrorAction SilentlyContinue
git push origin main
netlify deploy --prod --dir="."
pwsh ./scripts/canary.ps1
