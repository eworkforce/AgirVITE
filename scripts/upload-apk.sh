#!/bin/bash

# VITE App - APK Upload to Firebase Storage with QR Code Generation
# This script uploads the debug APK to Firebase Storage and generates a QR code for easy distribution

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APK_SOURCE="build/app/outputs/apk/debug/app-debug.apk"
APK_NAME="VITE-App.apk"
STORAGE_PATH="apk-releases/${APK_NAME}"
PROJECT_ID="agir-vite-v2"
QR_OUTPUT="qr-code-download.png"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   VITE App - APK Distribution Tool${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Step 1: Check if APK exists
echo -e "${YELLOW}[1/5]${NC} Checking for APK file..."
if [ ! -f "$APK_SOURCE" ]; then
    echo -e "${RED}✗ Error: APK file not found at $APK_SOURCE${NC}"
    echo -e "${YELLOW}Please run: flutter build apk --debug${NC}"
    exit 1
fi

APK_SIZE=$(du -h "$APK_SOURCE" | cut -f1)
echo -e "${GREEN}✓ Found APK: $APK_SOURCE ($APK_SIZE)${NC}"
echo ""

# Step 2: Check Firebase authentication
echo -e "${YELLOW}[2/5]${NC} Verifying Firebase authentication..."
if ! firebase projects:list > /dev/null 2>&1; then
    echo -e "${RED}✗ Error: Not authenticated with Firebase${NC}"
    echo -e "${YELLOW}Please run: firebase login${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Firebase authentication verified${NC}"
echo ""

# Step 3: Upload APK to Firebase Storage
echo -e "${YELLOW}[3/5]${NC} Uploading APK to Firebase Storage..."
echo -e "   Project: ${PROJECT_ID}"
echo -e "   Path: gs://${PROJECT_ID}.appspot.com/${STORAGE_PATH}"

# Create a temporary copy with the new name
TEMP_APK="/tmp/${APK_NAME}"
cp "$APK_SOURCE" "$TEMP_APK"

# Upload using Firebase CLI (requires Firebase Storage to be enabled)
# Note: We'll use gsutil as it's more reliable for large files
if command -v gsutil &> /dev/null; then
    # Upload with public-read ACL
    gsutil -m cp "$TEMP_APK" "gs://${PROJECT_ID}.appspot.com/${STORAGE_PATH}"
    gsutil acl ch -u AllUsers:R "gs://${PROJECT_ID}.appspot.com/${STORAGE_PATH}"
    echo -e "${GREEN}✓ APK uploaded successfully${NC}"
else
    echo -e "${YELLOW}⚠ gsutil not found. Using alternative method...${NC}"
    echo -e "${RED}✗ Error: Please install Google Cloud SDK for gsutil${NC}"
    echo -e "${YELLOW}Install: https://cloud.google.com/sdk/docs/install${NC}"
    echo ""
    echo -e "${BLUE}Alternative: Manual Upload Instructions${NC}"
    echo -e "1. Go to: https://console.firebase.google.com/project/${PROJECT_ID}/storage"
    echo -e "2. Click 'Get Started' to enable Firebase Storage"
    echo -e "3. Create folder: apk-releases"
    echo -e "4. Upload ${TEMP_APK} and rename to ${APK_NAME}"
    echo -e "5. Click on the file and copy the download URL"
    echo -e "6. Run: qrencode -o ${QR_OUTPUT} '<YOUR_URL>'"
    exit 1
fi

# Clean up temp file
rm "$TEMP_APK"
echo ""

# Step 4: Get download URL
echo -e "${YELLOW}[4/5]${NC} Generating download URL..."

# Get the download token from Firebase Storage
DOWNLOAD_URL="https://firebasestorage.googleapis.com/v0/b/${PROJECT_ID}.appspot.com/o/apk-releases%2F${APK_NAME}?alt=media"

echo -e "${GREEN}✓ Download URL generated${NC}"
echo -e "${BLUE}URL: ${DOWNLOAD_URL}${NC}"
echo ""

# Step 5: Generate QR Code
echo -e "${YELLOW}[5/5]${NC} Generating QR code..."

# Generate QR code as PNG
qrencode -s 10 -l H -o "$QR_OUTPUT" "$DOWNLOAD_URL"

# Also display QR code in terminal
echo -e "${GREEN}✓ QR code generated: ${QR_OUTPUT}${NC}"
echo ""
echo -e "${BLUE}QR Code (scan with phone):${NC}"
qrencode -t ANSIUTF8 "$DOWNLOAD_URL"
echo ""

# Step 6: Summary
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Upload Complete! ${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}📱 Distribution Instructions:${NC}"
echo ""
echo -e "1. ${GREEN}Share QR Code:${NC}"
echo -e "   - Show the QR code above to testers"
echo -e "   - Or share the image: ${QR_OUTPUT}"
echo ""
echo -e "2. ${GREEN}Direct Download Link:${NC}"
echo -e "   ${DOWNLOAD_URL}"
echo ""
echo -e "3. ${GREEN}Installation Steps for Testers:${NC}"
echo -e "   a. Scan QR code or open download link"
echo -e "   b. Download ${APK_NAME}"
echo -e "   c. Enable 'Install from Unknown Sources' if prompted"
echo -e "   d. Install and launch VITE App"
echo ""
echo -e "${YELLOW}⚠️  Note: First-time installers may need to:${NC}"
echo -e "   Settings > Security > Enable 'Unknown Sources'"
echo ""
echo -e "${BLUE}Firebase Console:${NC}"
echo -e "   https://console.firebase.google.com/project/${PROJECT_ID}/storage"
echo ""
