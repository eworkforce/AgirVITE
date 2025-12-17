# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

# Project Overview

`agir_vite` is a Flutter mobile application designed for stroke prevention in Côte d'Ivoire.
It uses an **Offline-First** architecture, relying on local persistence (Hive) and syncing with Firebase when connectivity allows.

**Key Features:**
- **Emergency Protocol:** Native calls to SAMU (185) and WhatsApp alerts to guardians.
- **BP Tracker:** AI-powered OCR (Gemini 1.5 Flash) with ML Kit fallback for reading blood pressure monitors.
- **Education:** Interactive Rive animations for stroke symptom recognition (V.I.T.E.).

# Common Commands

- **Run App**: `flutter run`
- **Install Dependencies**: `flutter pub get`
- **Code Generation** (Required for Riverpod, Freezed, Hive):
  - One-time build: `dart run build_runner build --delete-conflicting-outputs`
  - Watch mode (recommended during dev): `dart run build_runner watch --delete-conflicting-outputs`
- **Lint Code**: `flutter analyze`
- **Run Tests**:
  - Unit/Widget tests: `flutter test`
  - Single file: `flutter test test/path/to/file.dart`
- **Format Code**: `dart format .`

# Architecture & Structure

The project follows **Clean Architecture** principles with a **Feature-First** directory structure.

## Core Technology Stack
- **Framework**: Flutter (Impeller engine enabled)
- **State Management**: Riverpod (Code generation enabled)
- **Local DB**: Hive (Offline persistence)
- **Backend**: Firebase (Auth, Firestore, Functions, Storage)
- **AI/OCR**: Google Gemini 1.5 Flash (Online) + ML Kit (Offline)
- **Animations**: Rive (State Machines)

## Directory Breakdown (`lib/`)
- `lib/app/`: App-level config (Routes, Theme, `main` app widget).
- `lib/core/`: Shared business logic and services (not feature-specific).
  - `services/`: Interfaces for external interactions (API, device).
  - `repositories/`: Data access layer (mediates between Hive & Firestore).
  - `models/`: Data entities.
- `lib/features/`: Vertical slices of functionality (e.g., `onboarding`, `dashboard`, `emergency`).
  - Each feature contains: `screens/`, `widgets/`, `providers/`.
- `lib/data/`: Data layer implementation details.
  - `local/`: Hive boxes and adapters.
  - `remote/`: API clients (Firebase, Gemini).

## Key Documentation
Refer to the `docs/` directory for detailed specifications. **Future Agents: Read these if you need deep context.**
- **Architecture**: `docs/ARCHI.md` (System design, C4 diagrams, data flow)
- **Requirements**: `docs/PRD.md` (User stories, acceptance criteria)
- **Design**: `docs/DESIGN_SYSTEM.md` (Colors, typography, component styles)

# Development Guidelines

- **Offline-First**: Always write to Hive first, then sync to Firestore. Treat online as an enhancement.
- **Code Generation**: This project uses code generation heavily. Run `build_runner` after modifying models (`@freezed`, `@HiveType`) or providers (`@riverpod`).
- **UI/UX**: Adhere to the "Serene Wave" design system (Neomorphism/Glassmorphism).
- **Testing**:
  - Write unit tests for Repositories and Services.
  - Write widget tests for critical UI components.
