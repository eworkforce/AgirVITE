# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

# Project Overview

`agir_vite` is a Flutter mobile application designed for stroke prevention in Côte d'Ivoire.
It uses an **Offline-First** architecture, relying on local persistence (Hive) and syncing with Firebase when connectivity allows.

**Key Features:**
- **Emergency Protocol:** Native calls to SAMU (185) and WhatsApp alerts to guardians.
- **BP Tracker:** AI-powered OCR (Gemini 1.5 Flash) with ML Kit fallback for reading blood pressure monitors.
- **Education:** Interactive Rive animations for stroke symptom recognition (V.I.T.E.).
- **Social Health:** "Cercles de Vie" (Guardians) for community support.
- **Offline Resources:** Stroke center map and educational stories available without internet.

# Common Commands

## Development
- **Run App**: `flutter run`
- **Run on Specific Device**: `flutter run -d <device_id>`
- **Install Dependencies**: `flutter pub get`
- **Code Generation** (Required for Riverpod, Freezed, Hive):
  - One-time build: `dart run build_runner build --delete-conflicting-outputs`
  - Watch mode (recommended during dev): `dart run build_runner watch --delete-conflicting-outputs`

## Code Quality
- **Lint Code**: `flutter analyze`
- **Format Code**: `dart format .`
- **Auto-fix Issues**: `dart fix --apply`

## Testing
- **Run All Tests**: `flutter test`
- **Single Test File**: `flutter test test/path/to/file.dart`
- **Test with Coverage**: `flutter test --coverage`

## Build
- **Debug APK**: `flutter build apk --debug`
- **Release APK**: `flutter build apk --release`
- **App Bundle (Google Play)**: `flutter build appbundle --release`

# Architecture & Structure

The project follows **Clean Architecture** principles with a **Feature-First** directory structure.

## Core Technology Stack
- **Framework**: Flutter (Impeller engine enabled)
- **Language**: Dart 3.x (Null safety)
- **State Management**: Riverpod 2.x (Code generation enabled)
- **Local DB**: Hive 2.x (Offline persistence, NoSQL)
- **Backend**: Firebase (Auth, Firestore, Functions, Storage)
- **AI/OCR**: Google Gemini 1.5 Flash (Primary) + ML Kit (Fallback)
- **Animations**: Rive (State Machine-driven)
- **Mapping**: flutter_map (Offline-capable)

## Directory Breakdown (`lib/`)
- `lib/app/`: App-level config (Routes, Theme, `main` app widget).
- `lib/core/`: Shared business logic and services (not feature-specific).
  - `services/`: Interfaces for external interactions (API, device).
  - `repositories/`: Data access layer (mediates between Hive & Firestore).
  - `models/`: Data entities.
  - `utils/`: Helpers and constants.
- `lib/data/`: Data layer implementation details.
  - `local/`: Hive boxes and adapters.
  - `remote/`: API clients (Firebase, Gemini).
- `lib/features/`: Vertical slices of functionality.
  - `onboarding/`: Intro flow (Brand, Pledge, Reflex Drill).
  - `dashboard/`: Main home screen with bento grid.
  - `emergency/`: SOS button and emergency protocol logic.
  - `bp_tracker/`: Blood pressure capture (OCR) and history.
  - `vite_guide/`: Interactive symptom guide.
  - `map/`: Stroke center locator.
  - `stories/`: Educational content feed.
  - `guardians/`: Contact management for emergency alerts.
  - `profile/`: User settings and profile management.
  - `shared/`: Reusable widgets (buttons, modals).

## Key Documentation
Refer to the `docs/` directory for detailed specifications. **Future Agents: Read these if you need deep context.**
- **Architecture**: `docs/ARCHI.md` (System design, C4 diagrams, data flow)
- **Requirements**: `docs/PRD.md` (User stories, acceptance criteria)
- **Design**: `docs/DESIGN_SYSTEM.md` (Colors, typography, component styles)

# Development Guidelines

- **Offline-First**: Always write to Hive first, then sync to Firestore. Treat online as an enhancement.
- **Code Generation**: This project uses code generation heavily. Run `build_runner` after modifying models (`@freezed`, `@HiveType`) or providers (`@riverpod`).
- **UI/UX**: Adhere to the "Serene Wave" design system (Neomorphism/Glassmorphism). Avoid alarmist colors; use Terracotta for urgency.
- **Testing**:
  - Write unit tests for Repositories and Services.
  - Write widget tests for critical UI components.
- **Environment**: Keep sensitive keys in `.env` (not committed). Use `flutter_dotenv`.
