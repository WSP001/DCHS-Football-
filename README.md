# DCHS Football Reunion & Combine Banquet (1977–2025)

A comprehensive event website template for the **Dodge County High School (Eastman, GA)** football reunion and recognition banquet. This repository provides a complete static site solution with RSVP management, calendar integration, and automated GitHub issue tracking for event coordination.

## ✨ Features

- **🏈 Event Website**: Responsive static site with event details and schedule
- **📝 RSVP System**: Comprehensive form with volunteer sign-up and dietary preferences
- **📅 Calendar Integration**: Downloadable `.ics` calendar file for easy event scheduling
- **🎫 GitHub Issue Tracking**: Automatic issue creation from RSVP submissions via Netlify Functions
- **🎁 Silent Auction**: Built-in pages for fundraising auction coordination
- **🚀 Netlify Ready**: Zero-config deployment with form handling and serverless functions
- **📱 Mobile Responsive**: Optimized for all device sizes
- **♿ Accessible**: ADA-compliant design and accessibility features

## 🚀 Quick Start

### 1. Clone and Setup
```bash
git clone https://github.com/WSP001/DCHS-Football-.git
cd DCHS-Football-
```

### 2. Deploy to Netlify
1. **Fork this repository** to your GitHub account
2. **Connect to Netlify**: 
   - Go to [Netlify](https://netlify.com) and create a new site
   - Connect your GitHub repository
   - Build settings are configured in `netlify.toml` (no build command needed)
3. **Configure Environment Variables** in Netlify Dashboard:
   ```
   GITHUB_TOKEN=your_github_token
   GH_OWNER=your_github_username
   GH_REPO=your_repo_name
   ISSUE_DEFAULT_ASSIGNEES=username1,username2 (optional)
   WEBHOOK_SECRET=your_secret_key (optional)
   ```

### 3. Customize for Your Event
- Edit `2025/index.html` for event details and schedule
- Modify `index.html` for main landing page content
- Update `event.ics` with your event date/time/location
- Customize `survey-pipeline.html` form fields as needed

## 📁 Project Structure

```
├── index.html              # Main landing page
├── survey-pipeline.html    # RSVP and volunteer signup form
├── event.ics              # Calendar file for event
├── 2025/
│   └── index.html         # Detailed event information page
├── netlify/
│   └── functions/
│       └── issue-intake.js # Serverless function for GitHub issue creation
├── netlify.toml           # Netlify configuration
└── README.md              # This file
```

## 🔧 Configuration

### Environment Variables
Set these in your Netlify dashboard under Site Settings > Environment Variables:

| Variable | Required | Description |
|----------|----------|-------------|
| `GITHUB_TOKEN` | ✅ | GitHub personal access token with repo access |
| `GH_OWNER` | ✅ | GitHub username/organization |
| `GH_REPO` | ✅ | Repository name for issue creation |
| `ISSUE_DEFAULT_ASSIGNEES` | ❌ | Comma-separated list of default issue assignees |
| `WEBHOOK_SECRET` | ❌ | Optional secret for webhook verification |

### GitHub Token Setup
1. Go to GitHub Settings > Developer settings > Personal access tokens
2. Create a new token with `repo` scope
3. Copy the token and add it to Netlify environment variables

## 📋 RSVP Form Features

The RSVP form captures:
- **Personal Information**: Name, email, phone, graduation year
- **Attendance Details**: Guest count, decade table preference
- **Volunteer Opportunities**: Multiple volunteer roles available
- **Accessibility Needs**: Dietary restrictions and accessibility requirements
- **Recognition Team**: Program and recognition committee participation
- **Sponsorship Interest**: Business sponsorship opportunities
- **Memory Sharing**: Optional story and photo URL submission

### Form Submission Workflow
1. User submits RSVP form on website
2. Netlify processes form data
3. `issue-intake.js` function creates GitHub issue with:
   - Structured RSVP information
   - Appropriate labels for filtering
   - Assignment to designated team members
4. Event organizers manage RSVPs through GitHub Issues

## 🎨 Customization Guide

### For Different Years/Events
1. **Create new year folder** (e.g., `2026/`)
2. **Copy and modify** `2025/index.html` with new event details
3. **Update calendar file** `event.ics` with new date/time
4. **Modify main pages** to reference new year
5. **Update redirect rules** in `netlify.toml` if needed

### Styling Changes
- All styles are embedded in HTML files for simplicity
- Modify CSS within `<style>` tags in each HTML file
- Consistent color scheme: Primary `#003366`, Secondary `#0563c1`

### Form Customization
- Edit `survey-pipeline.html` to modify form fields
- Update `netlify/functions/issue-intake.js` to handle new fields
- Adjust GitHub issue template in the function

## 🚀 Local Development

### Testing Locally
```bash
# Install Netlify CLI
npm install -g netlify-cli

# Run local development server
netlify dev
```

This starts a local server with Netlify Functions support for testing the complete workflow.

### Testing Form Submissions
1. Start local development: `netlify dev`
2. Fill out RSVP form at `http://localhost:8888/survey-pipeline.html`
3. Check that GitHub issues are created (requires environment variables)

## 📊 GitHub Issue Labels

The system automatically applies labels to organize RSVPs:
- `attending-yes` - Confirmed attendees
- `volunteer-ops` - Check-in and operations volunteers
- `auction-donor` - Auction table volunteers and sponsors
- `stage-crew` - Stage and timing volunteers
- `media-team` - Social media and photography volunteers
- `accessibility` - Accessibility support volunteers
- `vip-host` - VIP hosting volunteers
- `general-volunteer` - General volunteers
- `recognition-team` - Program and recognition committee
- `sponsor-lead` - Sponsorship interested parties

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes and test locally
4. Commit with clear messages: `git commit -m "Add feature description"`
5. Push and create a Pull Request

## 📄 License

This project is released under the [CC0 1.0 Universal](LICENSE) license - feel free to use, modify, and distribute for your own reunion events.

## 📞 Support

For questions about setup or customization:
- Open an issue in this repository
- Review the [Netlify Functions documentation](https://docs.netlify.com/functions/overview/)
- Check [Netlify Forms documentation](https://docs.netlify.com/forms/setup/) for form handling

---

*Originally created for the Dodge County High School Football Reunion 2025. Adapted as a template for other reunion events.*