# 🌐 DCHS-Football.org - Complete DNS Setup Guide

## 📋 **DOMAIN CONFIGURATION OVERVIEW**

**Primary Domain**: dchs-football.org  
**Netlify Site**: dchs-football.netlify.app  
**Status**: Ready for DNS configuration

---

## 🎯 **REQUIRED DNS RECORDS**

### **1. Main Domain (dchs-football.org)**

| Type | Name | Value | TTL |
|------|------|-------|-----|
| **A** | @ | 75.2.60.5 | 3600 |
| **CNAME** | www | dchs-football.netlify.app | 3600 |

### **2. Subdomains**

| Type | Name | Value | TTL |
|------|------|-------|-----|
| **CNAME** | reunion | dchs-football.netlify.app | 3600 |
| **CNAME** | rsvp | dchs-football.netlify.app | 3600 |
| **CNAME** | dashboard | dchs-football.netlify.app | 3600 |

---

## 🔧 **STEP-BY-STEP DNS SETUP**

### **Option A: Using Your Domain Registrar's DNS**

1. **Log into your domain registrar** (where you bought dchs-football.org)
2. **Navigate to DNS Management** (usually called "DNS Settings" or "Name Servers")
3. **Add these records exactly as shown above**:
   `
   A Record:    @           →  75.2.60.5
   CNAME:       www         →  dchs-football.netlify.app
   CNAME:       reunion     →  dchs-football.netlify.app
   CNAME:       rsvp        →  dchs-football.netlify.app
   CNAME:       dashboard   →  dchs-football.netlify.app
   `
4. **Save changes** and wait 5-10 minutes for propagation

### **Option B: Using Netlify DNS (Recommended)**

1. **In your domain registrar**:
   - Change name servers to Netlify's:
     `
     dns1.p08.nsone.net
     dns2.p08.nsone.net
     dns3.p08.nsone.net
     dns4.p08.nsone.net
     `

2. **In Netlify admin panel**:
   - Go to Site Settings → Domain Management
   - Add custom domain: dchs-football.org
   - Netlify will automatically configure all DNS records

---

## ✅ **VERIFICATION CHECKLIST**

After DNS setup, these URLs should work:

- ✅ https://dchs-football.org
- ✅ https://www.dchs-football.org
- ✅ https://reunion.dchs-football.org
- ✅ https://rsvp.dchs-football.org
- ✅ https://dashboard.dchs-football.org
