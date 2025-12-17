# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

# Project Overview

This is a Flutter application named `agir_vite`. It is currently based on the default Flutter counter app template.

# Common Commands

- **Run App**: `flutter run`
  - Runs the app on the connected device or emulator.
- **Install Dependencies**: `flutter pub get`
  - Fetches dependencies listed in `pubspec.yaml`.
- **Lint Code**: `flutter analyze`
  - Runs static analysis to check for errors and lints.
- **Run Tests**: `flutter test`
  - Runs all tests in the `test/` directory.
- **Run Single Test File**: `flutter test test/path/to/test.dart`
  - Runs tests in a specific file.
- **Build APK (Android)**: `flutter build apk`
- **Build Web**: `flutter build web`

# Architecture & Structure

## Directory Structure
- `lib/`: Contains the main Dart source code.
  - `main.dart`: The application entry point (`main()` function) and root widget (`MyApp`).
- `test/`: Contains unit and widget tests.
  - `widget_test.dart`: Example widget test for the counter functionality.
- `android/`, `ios/`, `linux/`, `macos/`, `web/`, `windows/`: Platform-specific configuration and native code.
- `pubspec.yaml`: Manages Dart dependencies and project metadata.
- `analysis_options.yaml`: Configures linting rules.

## Architectural Patterns
- **Entry Point**: The app starts in `lib/main.dart`.
- **State Management**: Currently uses standard `StatefulWidget` and `setState` for local state management.
- **UI**: Built using Flutter Widgets (Material Design by default).

# Development Guidelines

- **Linting**: Ensure code passes `flutter analyze` before committing.
- **Testing**: Add widget tests for new UI components and unit tests for logic. Use `flutter test` to verify.
- **Formatting**: Use `dart format .` to format code.
