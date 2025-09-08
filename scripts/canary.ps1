$sites = @("https://dchs-football.org")
foreach ($site in $sites) {
  Write-Host "Canary: HEAD checks"
  foreach ($url in @("/thank-you", "/thank-you/", "/thank-you.html")) {
    $response = Invoke-WebRequest -Uri "$site$url" -Method HEAD -SkipHttpErrorCheck
    if ($response.StatusCode -notin @(200, 301, 302)) {
      throw "HEAD $url status $($response.StatusCode) (expected 200/301/302)"
    }
  }
  
  Write-Host "Canary: POST check (Netlify Forms)"
  # For Netlify Forms, we expect either:
  # - 200 with success content (if form processes immediately)
  # - 302/303 redirect to thank-you page with success query param
  $response = Invoke-WebRequest -Uri "$site/thank-you.html" -Method POST -Body @{
    "form-name" = "dchs-extended-survey"
    name = "Test User"
    email = "test@example.com"
  } -SkipHttpErrorCheck -MaximumRedirection 0
  
  if ($response.StatusCode -notin @(200, 302, 303)) {
    throw "POST status $($response.StatusCode) (expected 200/302/303)"
  }
  
  # If we got a redirect, check the Location header
  if ($response.StatusCode -in @(302, 303)) {
    $location = $response.Headers.Location
    Write-Host "POST redirected to: $location"
    if ($location -notmatch "/thank-you") {
      throw "POST redirect location unexpected: $location"
    }
  }
  
  Write-Host "✓ All canary checks passed for $site"
}
