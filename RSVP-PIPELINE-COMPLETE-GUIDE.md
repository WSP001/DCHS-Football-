# DCHS Football RSVP Pipeline - COMPLETE SETUP GUIDE

## 🚀 **PIPELINE STATUS: READY TO DEPLOY**

**Current Date:** September 7, 2025  
**Site:** dchs-football.org  
**RSVP URL:** rsvp.dchs-football.org  

---

## 0️⃣ **What "WORKING" Means**

1. ✅ Guest submits the survey at rsvp.dchs-football.org
2. ✅ Netlify Forms captures the data
3. ✅ Webhook triggers /.netlify/functions/issue-intake
4. ✅ GitHub Issue is created automatically
5. ✅ Page redirects to /thank-you.html
6. ✅ Dashboard shows updated stats from /.netlify/functions/stats

---

## 1️⃣ **NETLIFY FORMS WEBHOOK SETUP** (Critical Missing Piece)

### In Netlify Dashboard:

1. **Go to:** Site Settings → Forms → dchs-extended-survey
2. **Add notification:** Outgoing webhook
3. **Webhook URL:** /.netlify/functions/issue-intake
4. **Method:** POST
5. **Optional Header:**
   - **Name:** X-Webhook-Secret
   - **Value:** dchs-reunion-webhook-2025

### Environment Variables (Site Settings → Build & deploy → Environment):

GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx  # Personal Access Token with repo scope
GH_OWNER=WSP001
GH_REPO=DCHS-Football-
WEBHOOK_SECRET=dchs-reunion-webhook-2025

---

## 2️⃣ **CURRENT FORM STATUS** ✅

The survey-complete.html form is **CORRECTLY CONFIGURED** - NO CHANGES NEEDED

---

## 3️⃣ **GITHUB LABELS SETUP** (One-Time)

Run this once to create required labels:

gh label create "rsvp-survey" --color="0052cc" --description="RSVP Survey Submission"
gh label create "attending-yes" --color="0e8a16" --description="Will Attend Event"
gh label create "attending-no" --color="d93f0b" --description="Cannot Attend"
gh label create "attending-maybe" --color="fbca04" --description="Maybe Attending"
gh label create "volunteers" --color="5319e7" --description="Volunteered for Tasks"

---

## 4️⃣ **TESTING THE PIPELINE**

### Production Testing:
1. Submit form at rsvp.dchs-football.org
2. Check GitHub for new issue
3. Verify dashboard stats update

---

## 🔧 **TO COMPLETE:**
- [ ] **Configure Netlify Forms webhook** (Step 1)
- [ ] **Set environment variables** (Step 1)
- [ ] **Create GitHub labels** (Step 3)
- [ ] **Test pipeline end-to-end** (Step 4)

**👨‍💻 PROGRAMMER NOTE:** The form and functions are ready. Only the **Netlify webhook configuration** and **environment variables** need to be set up in the Netlify dashboard to complete the pipeline.
