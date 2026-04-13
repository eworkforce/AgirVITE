#!/bin/bash

# VITE App - Manual APK Distribution with QR Code
# Use this when Firebase Storage is not available

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
APK_SOURCE="build/app/outputs/apk/debug/app-debug.apk"
APK_OUTPUT="VITE-App.apk"
QR_OUTPUT="qr-code-download.png"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   VITE App - Manual Distribution${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Step 1: Check if APK exists
echo -e "${YELLOW}[1/4]${NC} Checking for APK file..."
if [ ! -f "$APK_SOURCE" ]; then
    echo -e "${RED}✗ Error: APK file not found at $APK_SOURCE${NC}"
    echo -e "${YELLOW}Please run: flutter build apk --debug${NC}"
    exit 1
fi

APK_SIZE=$(du -h "$APK_SOURCE" | cut -f1)
echo -e "${GREEN}✓ Found APK: $APK_SOURCE ($APK_SIZE)${NC}"
echo ""

# Step 2: Copy and rename APK
echo -e "${YELLOW}[2/4]${NC} Preparing APK for distribution..."
cp "$APK_SOURCE" "$APK_OUTPUT"
echo -e "${GREEN}✓ Created: $APK_OUTPUT${NC}"
echo ""

# Step 3: Show upload instructions
echo -e "${YELLOW}[3/4]${NC} ${CYAN}Manual Upload Instructions:${NC}"
echo ""
echo -e "${BLUE}Choose one of these methods:${NC}"
echo ""
echo -e "${GREEN}Option A: Google Drive${NC}"
echo "  1. Go to: https://drive.google.com"
echo "  2. Upload: $APK_OUTPUT"
echo "  3. Right-click → Share → Get link"
echo "  4. Set 'Anyone with the link' can view"
echo "  5. Copy the sharing link"
echo ""
echo -e "${GREEN}Option B: Dropbox${NC}"
echo "  1. Go to: https://www.dropbox.com"
echo "  2. Upload: $APK_OUTPUT"
echo "  3. Click 'Share' → Create link"
echo "  4. Copy the link (change 'dl=0' to 'dl=1' for direct download)"
echo ""
echo -e "${GREEN}Option C: Transfer.sh (Quick & Anonymous - 14 days)${NC}"
echo "  Run: curl --upload-file $APK_OUTPUT https://transfer.sh/$APK_OUTPUT"
echo ""
echo -e "${GREEN}Option D: WeTransfer${NC}"
echo "  1. Go to: https://wetransfer.com"
echo "  2. Upload: $APK_OUTPUT"
echo "  3. Get the download link"
echo ""
read -p "Press Enter after uploading to continue..."
echo ""

# Step 4: Generate QR Code
echo -e "${YELLOW}[4/4]${NC} Generating QR code..."
echo ""
echo -e "${CYAN}Enter the download URL:${NC}"
read -p "URL: " DOWNLOAD_URL

if [ -z "$DOWNLOAD_URL" ]; then
    echo -e "${RED}✗ Error: URL cannot be empty${NC}"
    exit 1
fi

# Generate QR code as PNG
qrencode -s 10 -l H -o "$QR_OUTPUT" "$DOWNLOAD_URL"

echo -e "${GREEN}✓ QR code generated: ${QR_OUTPUT}${NC}"
echo ""
echo -e "${BLUE}QR Code (scan with phone):${NC}"
echo ""
qrencode -t ANSIUTF8 "$DOWNLOAD_URL"
echo ""

# Summary
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Distribution Ready! ${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}📱 Files Created:${NC}"
echo -e "   • APK: ${GREEN}$APK_OUTPUT${NC} ($APK_SIZE)"
echo -e "   • QR Code: ${GREEN}$QR_OUTPUT${NC}"
echo ""
echo -e "${BLUE}📎 Download Link:${NC}"
echo -e "   ${CYAN}$DOWNLOAD_URL${NC}"
echo ""
echo -e "${BLUE}📤 Share with Testers:${NC}"
echo -e "   1. Show the QR code above"
echo -e "   2. Or share the ${QR_OUTPUT} file"
echo -e "   3. Or share the download link directly"
echo ""
echo -e "${BLUE}📲 Installation Steps for Testers:${NC}"
echo -e "   1. Scan QR code or open download link"
echo -e "   2. Download VITE-App.apk"
echo -e "   3. Enable 'Install from Unknown Sources'"
echo -e "   4. Install and launch"
echo ""
echo -e "${YELLOW}💡 Tip: Save this QR code for easy distribution!${NC}"
echo ""
