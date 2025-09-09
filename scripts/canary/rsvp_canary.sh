#!/usr/bin/env bash
set -euo pipefail

# Priority: NETLIFY_PREVIEW_URL (Deploy Preview) → BASE_URL (prod) → default prod
BASE="${NETLIFY_PREVIEW_URL:-${BASE_URL:-https://dchs-football.org}}"

echo "🔎 Canary target: $BASE"

curl -fsS "$BASE/thank-you"        >/dev/null
curl -fsS "$BASE/thank-you/"       >/dev/null
curl -fsS "$BASE/thank-you.html"   >/dev/null

# Optional: simulate a form POST if you expose a test endpoint or use a small hidden form
# curl -fsS -X POST "$BASE" -d "name=Canary&email=canary@example.com" >/dev/null || true

echo "✅ RSVP canary checks passed for $BASE"
