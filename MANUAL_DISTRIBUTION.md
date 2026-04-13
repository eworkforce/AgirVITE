# Manual APK Distribution Guide

## 🚀 Quick Start (2 Steps)

### Step 1: Build & Prepare APK
```bash
flutter build apk --debug
./scripts/generate-qr-manual.sh
```

### Step 2: Upload APK
The script will guide you through uploading to your preferred service.

---

## 📤 Upload Options

### Option A: Google Drive (Recommended)
**Best for:** Long-term storage, team sharing

1. Go to: https://drive.google.com
2. Upload `VITE-App.apk` (199MB)
3. Right-click → **Share** → **Get link**
4. Set to **"Anyone with the link"** can view
5. Copy the sharing link

**Important for Google Drive:**
- Standard sharing links redirect to Drive viewer page
- For direct download, modify the URL:
  - From: `https://drive.google.com/file/d/FILE_ID/view?usp=sharing`
  - To: `https://drive.google.com/uc?export=download&id=FILE_ID`

### Option B: Dropbox
**Best for:** Simple sharing

1. Go to: https://www.dropbox.com
2. Upload `VITE-App.apk`
3. Click **Share** → **Create link**
4. Copy the link
5. **Important:** Change `dl=0` to `dl=1` in the URL for direct download
   - From: `https://www.dropbox.com/s/xxxxx/VITE-App.apk?dl=0`
   - To: `https://www.dropbox.com/s/xxxxx/VITE-App.apk?dl=1`

### Option C: Transfer.sh (Fastest - No Account Needed)
**Best for:** Quick temporary sharing (files expire after 14 days)

Run this command in your terminal:
```bash
curl --upload-file VITE-App.apk https://transfer.sh/VITE-App.apk
```

You'll get a direct download URL immediately!

**Example output:**
```
https://transfer.sh/xxxxx/VITE-App.apk
```

### Option D: WeTransfer
**Best for:** Email-style sharing

1. Go to: https://wetransfer.com
2. Upload `VITE-App.apk`
3. Enter email or get link
4. Get the download link

---

## 🔗 URL Tips

### Google Drive Direct Download
If using Google Drive, convert the sharing URL to a direct download URL:

**Sharing URL:**
```
https://drive.google.com/file/d/1ABC123xyz/view?usp=sharing
```

**Direct Download URL:**
```
https://drive.google.com/uc?export=download&id=1ABC123xyz
```

### Dropbox Direct Download
Change the `dl` parameter from `0` to `1`:

**Sharing URL:**
```
https://www.dropbox.com/s/abc123/VITE-App.apk?dl=0
```

**Direct Download URL:**
```
https://www.dropbox.com/s/abc123/VITE-App.apk?dl=1
```

---

## 📱 Complete Workflow Example

### Using Transfer.sh (Fastest)

```bash
# 1. Build APK
flutter build apk --debug

# 2. Upload to transfer.sh
curl --upload-file build/app/outputs/apk/debug/app-debug.apk https://transfer.sh/VITE-App.apk

# Output will be something like:
# https://transfer.sh/xYz12/VITE-App.apk

# 3. Generate QR code directly
qrencode -o qr-code-download.png "https://transfer.sh/xYz12/VITE-App.apk"

# 4. Display QR in terminal
qrencode -t ANSIUTF8 "https://transfer.sh/xYz12/VITE-App.apk"
```

### Using Google Drive (Most Reliable)

1. **Build:**
   ```bash
   flutter build apk --debug
   cp build/app/outputs/apk/debug/app-debug.apk VITE-App.apk
   ```

2. **Upload to Google Drive** via web browser

3. **Get and modify link:**
   - Original: `https://drive.google.com/file/d/1ABC123xyz/view?usp=sharing`
   - Modified: `https://drive.google.com/uc?export=download&id=1ABC123xyz`

4. **Generate QR:**
   ```bash
   qrencode -o qr-code-download.png "https://drive.google.com/uc?export=download&id=1ABC123xyz"
   qrencode -t ANSIUTF8 "https://drive.google.com/uc?export=download&id=1ABC123xyz"
   ```

---

## 📲 For Testers: Installation Guide

### Step 1: Download
- Scan QR code with phone camera
- Or tap the download link

### Step 2: Enable Unknown Sources
**Android 8.0+ (Oreo and newer):**
1. When prompted, tap **Settings**
2. Enable **"Allow from this source"** for your browser

**Android 7.0 and older:**
1. Go to **Settings** → **Security**
2. Enable **"Unknown sources"**
3. Tap **OK** to confirm

### Step 3: Install
1. Tap the downloaded **VITE-App.apk** file
2. Tap **Install**
3. Wait for installation to complete
4. Tap **Open** or find the app in your app drawer

---

## 🛠️ Troubleshooting

### "Can't download file" error
**Solution:** Make sure you're using a direct download URL
- Google Drive: Use the `uc?export=download` format
- Dropbox: Use `dl=1` instead of `dl=0`

### "File too large for antivirus scan" (Google Drive)
**Solution:** This is normal for files over 100MB. Click **"Download anyway"**

### APK won't install
**Check:**
1. Unknown sources is enabled
2. Sufficient storage space (need ~400MB)
3. File downloaded completely (should be ~199MB)

### QR code won't scan
**Solutions:**
- Ensure good lighting
- Hold phone steady
- Try scanning the PNG file instead
- Manually type/share the URL

---

## 💾 File Storage Comparison

| Service | Max Size | Duration | Account? | Direct Download? |
|---------|----------|----------|----------|------------------|
| Google Drive | 15GB (free) | Unlimited | Yes | Yes (with modified URL) |
| Dropbox | 2GB (free) | Unlimited | Yes | Yes (with `dl=1`) |
| Transfer.sh | 10GB | 14 days | No | Yes |
| WeTransfer | 2GB (free) | 7 days | No | Yes |

---

## 🔄 Update Process

When releasing a new version:

1. **Build new APK:**
   ```bash
   flutter build apk --debug
   ```

2. **Choose approach:**
   - **Same URL:** Replace file on Google Drive/Dropbox (QR code stays same!)
   - **New URL:** Upload to Transfer.sh and generate new QR code

3. **Share with testers**

---

## 📊 Recommended Setup

**For Active Development (Weekly updates):**
- Use **Transfer.sh** for quick sharing
- Create new QR code each week

**For Beta Testing (Stable releases):**
- Use **Google Drive** or **Dropbox**
- Replace APK file to keep same download URL
- QR code works for all updates!

**For Field Testing (Rural Côte d'Ivoire):**
- Use **Google Drive** (most reliable)
- Generate QR code and print physical copies
- Share direct download URL via SMS/WhatsApp

---

## 🎯 Best Practices

1. **Always rename APK to `VITE-App.apk`** for consistency
2. **Test the download link** before sharing
3. **Keep QR code file** (`qr-code-download.png`) for easy distribution
4. **Share installation instructions** with testers
5. **Use direct download URLs** to avoid confusion

---

## 📞 Quick Commands Reference

```bash
# Build APK
flutter build apk --debug

# Rename APK
cp build/app/outputs/apk/debug/app-debug.apk VITE-App.apk

# Upload to Transfer.sh
curl --upload-file VITE-App.apk https://transfer.sh/VITE-App.apk

# Generate QR code
qrencode -o qr-code-download.png "YOUR_DOWNLOAD_URL"

# Show QR in terminal
qrencode -t ANSIUTF8 "YOUR_DOWNLOAD_URL"

# Or use the automated script
./scripts/generate-qr-manual.sh
```
