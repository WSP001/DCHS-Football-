#!/bin/bash
# Script to create GitHub labels for DCHS Football repository
# Requires GitHub CLI (gh) to be installed and authenticated
# Usage: ./create-labels.sh

# Authenticate GitHub CLI (if not done)
# gh auth login
# gh repo set-default WSP001/DCHS-Football-

# Define labels: name|color|description
labels=(
    "volunteer-ops|#0366d6|Check-In & Ops"
    "auction-donor|#b60205|Auction item or donor"
    "stage-crew|#5319e7|Stage & Setup"
    "media-team|#0e8a16|Photography & Video"
    "accessibility|#1d76db|Accessibility Support"
    "vip-host|#fbca04|VIP & Recognition Host"
    "general-volunteer|#c5def5|General Volunteer"
    "recognition-team|#d93f0b|Recognition Ceremony"
    "sponsor-lead|#0052cc|Sponsorship Contact"
    "attending-yes|#2ea44f|Confirmed Attending"
    "attending-no|#d73a49|Not Attending"
    "attending-maybe|#fbca04|Maybe Attending"
)

echo "Creating GitHub labels for DCHS Football repository..."

for label in "${labels[@]}"; do
    IFS='|' read -r name color desc <<< "$label"
    gh label create "$name" --color "$color" --description "$desc" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "✓ Label: $name"
    else
        echo "⚠ Label already exists or failed: $name"
    fi
done

echo "Label creation complete!"