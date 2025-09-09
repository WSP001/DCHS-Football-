# SECURITY-GUIDE.md

## Admin Access Control & Session Management

### Two-Layer Security Model
1. **Portal Gate**: Code + email verification required
2. **Dashboard Guard**: Session token validation on each page load
3. **4-Hour Auto-Logout**: Enforced session expiration
4. **No Repository Secrets**: All access codes stored in Netlify env vars

### Access Patterns (Secure)
- Portal access requires **both** verification code AND authorized email
- Session tokens auto-expire after 4 hours of inactivity
- All admin pages have `noindex,nofollow` meta tags
- Dashboard validates session on every load

### Environment Variables Required
```bash
# Set these in Netlify Site Settings → Environment Variables
ADMIN_ACCESS_CODE_PRIMARY=xxxx        # Primary access code
ADMIN_ACCESS_CODE_SECONDARY=yyyy      # Backup access code  
ADMIN_EXPORT_TOKEN=zzzz               # Bearer token for export API
AUTHORIZED_ADMIN_EMAILS=email1@example.com,email2@example.com
```

### Session Security Rules
- **4-hour timeout**: Auto-logout after inactivity
- **Token rotation**: New token on each successful login
- **Secure storage**: sessionStorage (cleared on browser close)
- **Path isolation**: Admin pages isolated from public routes

### Admin Portal Implementation
```html
<!-- Sample admin gate (use env vars, not hardcoded) -->
<script>
  function validateAccess() {
    const code = prompt('Access Code:');
    const email = prompt('Admin Email:');
    
    // Validate against env vars (server-side)
    fetch('/.netlify/functions/validate-admin', {
      method: 'POST',
      body: JSON.stringify({ code, email })
    }).then(response => {
      if (response.ok) {
        return response.json();
      }
      throw new Error('Access denied');
    }).then(data => {
      sessionStorage.setItem('adminToken', data.token);
      location.href = '/dashboard.html';
    }).catch(() => {
      alert('Access denied. Contact team lead.');
    });
  }
</script>
```

### Dashboard Guard Implementation
```javascript
// dashboard.html - token validation on load
function validateSession() {
  const token = sessionStorage.getItem('adminToken');
  if (!token) {
    location.href = '/admin-access.html';
    return;
  }
  
  // Validate token server-side
  fetch('/.netlify/functions/validate-session', {
    headers: { 'Authorization': `Bearer ${token}` }
  }).then(response => {
    if (!response.ok) {
      sessionStorage.clear();
      location.href = '/admin-access.html';
    }
  });
  
  // Auto-logout after 4 hours
  setTimeout(() => {
    sessionStorage.clear();
    alert('Session expired. Please log in again.');
    location.href = '/admin-access.html';
  }, 4 * 60 * 60 * 1000);
}

// Run on every dashboard load
document.addEventListener('DOMContentLoaded', validateSession);
```

### Troubleshooting
- **Access Denied**: Verify code and email with team lead
- **Session Expired**: Re-authenticate through portal
- **Export Fails**: Check ADMIN_EXPORT_TOKEN in Netlify settings
- **Page Not Loading**: Clear sessionStorage and retry

### Security Audit Checklist
- [ ] No plaintext codes in repository
- [ ] All secrets in Netlify environment variables
- [ ] Admin pages have noindex/nofollow meta tags
- [ ] Session tokens expire after 4 hours
- [ ] Dashboard validates token on each load
- [ ] Admin portal requires code + email
- [ ] Export API requires Bearer token
- [ ] All admin routes excluded from public navigation

### Incident Response
1. **Suspicious Access**: Rotate all access codes immediately
2. **Session Compromise**: Clear all active sessions, force re-auth
3. **Data Breach**: Audit export logs, notify stakeholders
4. **System Compromise**: Disable admin functions, audit access patterns

### Regular Maintenance
- **Quarterly**: Rotate access codes and export tokens
- **Monthly**: Review admin access logs
- **Weekly**: Verify session timeout enforcement
- **Daily**: Monitor failed authentication attempts
