# APK Distribution Quick Reference

## 🚀 Quick Start (3 Steps)

### 1. Enable Firebase Storage (One-Time Setup)
```
1. Visit: https://console.firebase.google.com/project/agir-vite-v2/storage
2. Click "Get Started"
3. Choose "Start in production mode"
4. Deploy rules: firebase deploy --only storage
```

### 2. Build & Upload APK
```bash
# Build the APK
flutter build apk --debug

# Upload and generate QR code
./scripts/upload-apk.sh
```

### 3. Share with Testers
- Show the QR code displayed in terminal
- Or share `qr-code-download.png` file
- Or share the direct download link

---

## 📱 For Testers: How to Install

1. **Scan QR Code** with phone camera
2. **Download** VITE-App.apk
3. **Enable Unknown Sources**:
   - Settings → Security → Enable "Unknown Sources"
   - Or Settings → Apps → Install unknown apps → Enable for browser
4. **Install** by tapping the downloaded APK
5. **Launch** VITE App

---

## 🔧 System Components

### Created Files
- `.firebaserc` - Firebase project configuration
- `storage.rules` - Storage security rules
- `scripts/upload-apk.sh` - Upload automation script
- `firebase.json` - Updated with storage rules reference

### Security Rules
Location: `storage.rules`
- **Public Read Access**: Anyone with URL can download APKs from `/apk-releases/`
- **Authenticated Write**: Only authenticated users can upload
- **Protected**: All other paths require authentication

### Upload Script Features
- ✅ Validates APK exists
- ✅ Renames to `VITE-App.apk`
- ✅ Uploads to Firebase Storage
- ✅ Generates download URL
- ✅ Creates QR code (PNG + Terminal display)
- ✅ Provides installation instructions

---

## 📂 File Locations

```
APK Input:  build/app/outputs/apk/debug/app-debug.apk
APK Output: VITE-App.apk (uploaded to Firebase)
Storage:    gs://agir-vite-v2.appspot.com/apk-releases/VITE-App.apk
QR Code:    qr-code-download.png (auto-generated)
```

---

## 🛠️ Troubleshooting

### Firebase Storage Not Enabled
**Error:** "Firebase Storage has not been set up"
**Solution:** Follow Step 1 above to enable Firebase Storage

### gsutil Not Found
**Error:** "gsutil: command not found"
**Solution:**
- Install Google Cloud SDK: https://cloud.google.com/sdk/docs/install
- Or use manual upload (see README.md)

### APK Won't Install on Phone
**Causes:**
- "Unknown Sources" not enabled
- Insufficient storage space
- Corrupted download

**Solutions:**
- Enable "Unknown Sources" in phone settings
- Clear some storage space
- Re-download the APK

### QR Code Won't Scan
**Solutions:**
- Ensure good lighting
- Hold phone steady
- Scan the `qr-code-download.png` file instead
- Manually share the download URL

---

## 🔄 Update Process

When you release a new version:

```bash
# 1. Build new APK
flutter build apk --debug

# 2. Upload (overwrites previous version)
./scripts/upload-apk.sh

# 3. Share new QR code with testers
# Previous QR codes will automatically download the new version
```

**Note:** The script always uses the same filename (`VITE-App.apk`), so the download URL remains constant. Testers can use the same QR code for all updates!

---

## 📊 Firebase Console Links

- **Storage:** https://console.firebase.google.com/project/agir-vite-v2/storage
- **Project Dashboard:** https://console.firebase.google.com/project/agir-vite-v2/overview
- **APK Folder:** Navigate to `apk-releases/` in Storage console

---

## 🔐 Security Notes

- APKs are publicly accessible via download URL (by design for easy testing)
- Download URLs contain Firebase-generated tokens
- Tokens can be revoked via Firebase Console if needed
- No sensitive data in APK (follows `.env` pattern per ARCHI.md)
- Write access requires Firebase authentication

---

## 💡 Tips

1. **Keep QR Code Handy:** Save `qr-code-download.png` to share via WhatsApp/Email
2. **Test Before Sharing:** Install on your own device first
3. **Use Release APK for Production:** This system works for both debug and release APKs
4. **Track Downloads:** Enable Firebase Analytics to monitor downloads
5. **Version Management:** Consider adding version numbers to filename for tracking

---

## 📞 Support

For issues or questions:
- Check troubleshooting section above
- Review main README.md for detailed documentation
- Check Firebase Console for upload status
- Verify storage rules are deployed: `firebase deploy --only storage`
