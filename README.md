# AgirVITE

A Flutter-based cross-platform application built with Dart, designed for modern mobile and web experiences.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the Application](#running-the-application)
- [Build & Deployment](#build--deployment)
- [Project Architecture](#project-architecture)
- [Technologies & Dependencies](#technologies--dependencies)
- [Firebase Integration](#firebase-integration)
- [Testing](#testing)
- [Code Quality](#code-quality)
- [Development Guidelines](#development-guidelines)
- [Contributing](#contributing)
- [License](#license)

## Overview

**AgirVITE** is a comprehensive Flutter application built by the eWorkforce team. It leverages the power of Flutter to deliver a seamless, native-like experience across multiple platforms including iOS, Android, Web, Windows, macOS, and Linux.

The project is actively maintained and structured to support rapid development, testing, and deployment workflows.

## Features

- ✨ **Cross-Platform Support**: Run on iOS, Android, Web, Windows, macOS, and Linux
- 🔥 **Firebase Integration**: Real-time database and backend services
- 📱 **Responsive Design**: Optimized UI for all screen sizes
- 🎨 **Modern Architecture**: Built with best practices and clean code principles
- 🧪 **Testing Ready**: Comprehensive test structure included
- 🔧 **Developer Friendly**: Well-organized project structure with development tools

## Project Structure

```
AgirVITE/
├── lib/                          # Main Flutter application code
├── test/                         # Unit and widget tests
├── android/                      # Android platform-specific code
├── ios/                          # iOS platform-specific code
├── web/                          # Web platform-specific code
├── windows/                      # Windows platform-specific code
├── macos/                        # macOS platform-specific code
├── linux/                        # Linux platform-specific code
├── assets/                       # Images, fonts, and static resources
├── docs/                         # Project documentation
├── pubspec.yaml                  # Flutter dependencies and project metadata
├── pubspec.lock                  # Locked dependency versions
├── analysis_options.yaml         # Dart analysis configuration
├── firebase.json                 # Firebase configuration
├── WARP.md                       # WARP protocol documentation
├── ToReadyForReviewStage.md      # Pre-review checklist and guidelines
└── .vscode/                      # VS Code workspace settings
```

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (latest stable version)
  - Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (included with Flutter)
- **Android Studio** or **Xcode** (for mobile development)
- **Git** (for version control)
- **Node.js** (optional, for web-related tools)
- **Firebase CLI** (for backend integration)

### Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/eworkforce/AgirVITE.git
   cd AgirVITE
   ```

2. **Get Flutter Dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Set up your Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   - Run Firebase initialization:
     ```bash
     firebase init
     ```
   - Update the `firebase.json` configuration file with your project details

4. **Verify Setup**
   ```bash
   flutter doctor
   ```
   Ensure all required dependencies are installed and configured.

### Running the Application

#### Mobile Development

**Run on Android:**
```bash
flutter run -d android
```

**Run on iOS:**
```bash
flutter run -d ios
```

**Run on all connected devices:**
```bash
flutter run
```

#### Web Development

```bash
flutter run -d chrome
```

#### Desktop Development

**Windows:**
```bash
flutter run -d windows
```

**macOS:**
```bash
flutter run -d macos
```

**Linux:**
```bash
flutter run -d linux
```

### Build & Deployment

#### Android Build

**Debug APK:**
```bash
flutter build apk --debug
```

**Release APK:**
```bash
flutter build apk --release
```

**App Bundle (for Google Play):**
```bash
flutter build appbundle --release
```

#### iOS Build

```bash
flutter build ios --release
```

#### Web Build

```bash
flutter build web --release
```

#### Desktop Builds

**Windows:**
```bash
flutter build windows --release
```

**macOS:**
```bash
flutter build macos --release
```

**Linux:**
```bash
flutter build linux --release
```

### APK Distribution (Testing & Internal Releases)

The project includes an automated APK distribution system using Firebase Storage and QR codes for easy testing.

#### Prerequisites
- Firebase Storage must be enabled in Firebase Console
- Google Cloud SDK with `gsutil` installed (optional but recommended)
- `qrencode` tool installed (already available on Linux Mint)

#### Quick Start

**1. Build the APK:**
```bash
flutter build apk --debug
```

**2. Upload and Generate QR Code:**
```bash
./scripts/upload-apk.sh
```

This script will:
- Verify the APK exists
- Rename it to `VITE-App.apk`
- Upload to Firebase Storage at `apk-releases/VITE-App.apk`
- Generate a download URL
- Create a QR code (displayed in terminal + saved as `qr-code-download.png`)
- Provide installation instructions

**3. Share with Testers:**
- Show the QR code displayed in the terminal
- Or share the `qr-code-download.png` file
- Or share the direct download link

#### For Testers: Installation Instructions

1. **Scan QR Code** with your phone camera or QR code reader
2. **Download** the APK file (`VITE-App.apk`)
3. **Enable Installation from Unknown Sources** (if prompted):
   - Go to Settings > Security > Enable "Unknown Sources"
   - Or Settings > Apps > Special Access > Install unknown apps > Enable for your browser
4. **Install** the APK by tapping on the downloaded file
5. **Launch** VITE App from your app drawer

#### Enabling Firebase Storage (First Time Only)

If Firebase Storage is not enabled:

1. Go to [Firebase Console](https://console.firebase.google.com/project/agir-vite-v2/storage)
2. Click "Get Started" to enable Firebase Storage
3. Choose "Start in production mode" (our storage.rules are already configured)
4. Re-run the deployment: `firebase deploy --only storage`
5. Run the upload script again: `./scripts/upload-apk.sh`

#### Manual Upload (Alternative Method)

If the automated script fails:

1. Build APK: `flutter build apk --debug`
2. Go to [Firebase Console Storage](https://console.firebase.google.com/project/agir-vite-v2/storage)
3. Create folder `apk-releases`
4. Upload `build/app/outputs/apk/debug/app-debug.apk`
5. Rename to `VITE-App.apk`
6. Click on the file and copy the download URL
7. Generate QR code: `qrencode -o qr-code.png '<YOUR_URL>'`

#### Troubleshooting

**"gsutil not found" error:**
- Install Google Cloud SDK: https://cloud.google.com/sdk/docs/install
- Or use the manual upload method above

**"Firebase Storage not enabled" error:**
- Follow the "Enabling Firebase Storage" instructions above

**APK won't install on phone:**
- Ensure "Unknown Sources" is enabled
- Check if sufficient storage space is available
- Try downloading again if file is corrupted

**QR code won't scan:**
- Ensure good lighting and steady phone
- Try scanning the `qr-code-download.png` file instead
- Or manually type/share the download URL

## Project Architecture

The project follows a modular architecture pattern:

### Directory Organization

- **lib/** - Main application code
  - Core business logic and domain models
  - UI screens and widgets
  - Service layer and repositories
  - State management solutions
  - Utilities and helpers

- **test/** - Automated tests
  - Unit tests for business logic
  - Widget tests for UI components
  - Integration tests

### Code Organization Best Practices

- Use feature-based folder structure
- Separate concerns into models, views, and controllers
- Follow Dart naming conventions
- Implement dependency injection for better testability
- Use state management patterns (Provider, Riverpod, or GetX)

## Technologies & Dependencies

This project utilizes several key technologies and packages:

- **Flutter**: Cross-platform mobile framework
- **Dart**: Programming language
- **Firebase**: Backend services (Firestore, Authentication, Cloud Functions)
- **pubspec.yaml**: Contains all project dependencies

To view all dependencies, check the `pubspec.yaml` file:
```bash
cat pubspec.yaml
```

Key features enabled:
- Real-time database synchronization
- User authentication
- Cloud storage
- Push notifications
- Analytics

## Firebase Integration

The project includes Firebase integration for backend services. Configuration is managed through:

- `firebase.json` - Firebase project configuration
- `.firebaserc` - Firebase project aliases (if present)

### Firebase Features

- **Firestore**: Real-time NoSQL database
- **Authentication**: User login and registration
- **Cloud Functions**: Serverless backend logic
- **Storage**: File and media storage
- **Messaging**: Push notifications

## Testing

### Running Tests

**Run all tests:**
```bash
flutter test
```

**Run tests with coverage:**
```bash
flutter test --coverage
```

**Run specific test file:**
```bash
flutter test test/path/to/test_file.dart
```

### Test Structure

- Place unit tests in `test/` directory
- Follow naming convention: `*_test.dart`
- Use descriptive test names
- Maintain high code coverage

## Code Quality

### Analysis

The project includes strict Dart analysis rules via `analysis_options.yaml`.

**Run analysis:**
```bash
flutter analyze
```

**Fix issues:**
```bash
dart fix --apply
```

### Formatting

**Format all Dart files:**
```bash
dart format lib/ test/
```

**Check formatting:**
```bash
dart format --set-exit-if-changed lib/ test/
```

## Development Guidelines

### Before Committing

Please follow the checklist in `ToReadyForReviewStage.md` to ensure your code is ready for review:
- Run tests and ensure they pass
- Run analysis and fix warnings
- Format code properly
- Update documentation
- Verify on multiple platforms

### WARP Protocol

Refer to `WARP.md` for information about the project's specific protocols and architectural patterns.

### Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent indentation (2 spaces)

## Contributing

We welcome contributions to AgirVITE! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please ensure your code passes all tests and analysis checks before submitting a PR.

## Version Information

- **Repository**: eworkforce/AgirVITE
- **Primary Language**: Dart
- **Framework**: Flutter
- **Created**: December 2025
- **Default Branch**: master

## Useful Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Best Practices](https://flutter.dev/docs/testing)

## Support

For issues, questions, or suggestions, please:

1. Check existing issues in the [GitHub Issues](https://github.com/eworkforce/AgirVITE/issues)
2. Create a new issue with detailed information
3. Contact the eWorkforce team

## License

This project is licensed under the terms specified in the repository. See the LICENSE file for details (if present).

---

**Made with ❤️ by [eWorkforce](https://github.com/eworkforce)**