# GitHub Labels for DCHS Football Repository

This repository uses GitHub labels to categorize issues created from the RSVP form submissions.

## Label Categories

### Attendance Status
- `attending-yes` (#2ea44f) - Confirmed Attending
- `attending-no` (#d73a49) - Not Attending  
- `attending-maybe` (#fbca04) - Maybe Attending

### Volunteer Roles
- `volunteer-ops` (#0366d6) - Check-In & Ops
- `auction-donor` (#b60205) - Auction item or donor
- `stage-crew` (#5319e7) - Stage & Setup
- `media-team` (#0e8a16) - Photography & Video
- `accessibility` (#1d76db) - Accessibility Support
- `vip-host` (#fbca04) - VIP & Recognition Host
- `general-volunteer` (#c5def5) - General Volunteer
- `recognition-team` (#d93f0b) - Recognition Ceremony
- `sponsor-lead` (#0052cc) - Sponsorship Contact

## Creating Labels

### Using the Shell Script
Run the provided script to create all labels:
```bash
./create-labels.sh
```

### Prerequisites
- GitHub CLI (`gh`) must be installed
- Must be authenticated: `gh auth login`
- Set default repo: `gh repo set-default WSP001/DCHS-Football-`

### Manual Creation
Labels can also be created manually through the GitHub web interface or using individual `gh label create` commands.

## How Labels Are Applied

Labels are automatically applied to issues created via the `netlify/functions/issue-intake.js` function based on form submissions:

- **Attendance labels**: Based on the "attending" field value (Yes/No/Maybe)
- **Volunteer labels**: Based on checked volunteer interest boxes
- **Special roles**: Based on recognition team and sponsor interest checkboxes

## Form Fields to Label Mapping

| Form Field | Label Applied |
|------------|---------------|
| `attending="Yes"` | `attending-yes` |
| `attending="No"` | `attending-no` |
| `attending="Maybe"` | `attending-maybe` |
| `volunteer_checkin=true` | `volunteer-ops` |
| `volunteer_auction=true` | `auction-donor` |
| `volunteer_stage=true` | `stage-crew` |
| `volunteer_media=true` | `media-team` |
| `volunteer_access=true` | `accessibility` |
| `volunteer_vip=true` | `vip-host` |
| `volunteer_any=true` | `general-volunteer` |
| `recognition_team=true` | `recognition-team` |
| `sponsor_interest=true` | `sponsor-lead` |