# DCHS Football Dashboard - Security Implementation Guide

## 🔒 ADMIN ACCESS CONTROL SYSTEM

### **Two-Layer Security Protection**

#### **Layer 1: Admin Access Portal**
- **URL**: `https://dchs-football.netlify.app/admin-access.html`
- **Authentication**: Code + Email combination
- **Session Duration**: 4 hours auto-logout
- **Failed Login**: Clears form, shows error message

#### **Layer 2: Dashboard Guard**
- **Access Check**: Validates session token on every dashboard load
- **Token Expiry**: Automatic redirect after 4 hours
- **Security Features**: Base64 encoded tokens with timestamp

---

## 🎯 ADMIN ACCESS CODES (CONFIDENTIAL)

### **Primary Admin Team**
- **Code**: `DCHS2025ADMIN`
- **Emails**: 
  - `admin@dchsfootballalumni.org`
  - `events@dchsfootballalumni.org`

### **Finance & Volunteer Team**
- **Code**: `FOOTBALL2025`
- **Emails**:
  - `finance@dchsfootballalumni.org`
  - `volunteer@dchsfootballalumni.org`

### **Secondary Admin Team**
- **Code**: `INDIANS2025`
- **Emails**:
  - `admin@dchs-football.org`
  - `coordinator@dchs-football.org`

---

## 🛡️ SECURITY FEATURES

### **Accidental Access Prevention**
✅ Alumni cannot accidentally find dashboard URL  
✅ Search engines blocked (`noindex,nofollow`)  
✅ No direct links from public pages  
✅ Requires both code AND email to access  

### **Data Protection**
✅ Confirmation dialog before refreshing metrics  
✅ Session timeout after 4 hours of inactivity  
✅ Logout button prominently displayed  
✅ Admin email shown in header for verification  

### **Error Handling**
✅ Invalid credentials clear form automatically  
✅ Expired sessions redirect to login  
✅ Corrupted tokens force re-authentication  

---

## 📋 ADMIN TEAM SETUP CHECKLIST

### **Step 1: Distribute Access Codes**
- [ ] Share codes via secure method (encrypted email/phone)
- [ ] Assign codes based on admin roles
- [ ] Test login with each admin team member

### **Step 2: Security Training**
- [ ] Never share access codes publicly
- [ ] Always logout when finished
- [ ] Use confirmation dialogs for data refresh
- [ ] Report any suspicious access attempts

### **Step 3: Access Management**
- [ ] Change codes periodically (quarterly)
- [ ] Remove access for departing team members
- [ ] Monitor admin activity in sessions

---

## 🚨 TROUBLESHOOTING

### **"Invalid Credentials" Error**
- Check code spelling (case-sensitive)
- Verify email matches authorized list
- Ensure email is lowercase

### **"Session Expired" Message**
- Login again with valid credentials
- Sessions last 4 hours maximum
- Browser refresh resets timer

### **Can't Access Dashboard**
- Clear browser cache/cookies
- Try incognito/private browsing mode
- Contact system administrator

---

## 🔐 CHANGING ACCESS CODES

To update access codes, edit the `validCodes` object in `admin-access.html`:

```javascript
const validCodes = {
    'NEW_CODE_2026': ['admin@domain.org'],
    'UPDATED_CODE': ['finance@domain.org']
};
```

**Important**: Always test new codes before removing old ones!

---

**🏈 "Keep access secure • Once a Indian, Always a Indian"**
