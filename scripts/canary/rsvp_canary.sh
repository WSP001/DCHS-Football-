#!/bin/bash
set -euo pipefail
BASE="${BASE_URL:-https://dchs-football.org}"
curl -fsS "$BASE/thank-you"        >/dev/null
curl -fsS "$BASE/thank-you/"       >/dev/null
curl -fsS "$BASE/thank-you.html"   >/dev/null
# Optional: simulate form POST endpoint if exposed for test
# curl -fsS -X POST "$BASE" -d "name=Canary&email=canary@example.com" >/dev/null || true
echo "RSVP canary checks passed ✅"
