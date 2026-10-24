# Features Presentation DOX Contract

Durable guidance for presentation slices, UI screens, widgets, animations, and Riverpod providers.

## Purpose

Owns all feature-first presentation code, screen flows, widget hierarchies, visual animations, and Riverpod state notifiers.

## Ownership

- `lib/features/onboarding/`: Onboarding flow (`BrandScreen`, `PledgeScreen`, `ReflexDrillScreen`, `ProfileSetupScreen`).
- `lib/features/dashboard/`: Main dashboard, welcome banner, quick action cards, BP status summary.
- `lib/features/emergency/`: Persistent SOS button with 2-second long-press tactile gesture.
- `lib/features/bp_tracker/`: Camera capture, manual entry, OCR review, BP history hub.
- `lib/features/vite_guide/`: Tabbed educational module (Visage, Incapacité, Trouble, En Urgence).
- `lib/features/map/`: Stroke center map, center details sheet, route indicators, location markers.
- `lib/features/stories/`: Educational video feed with offline playback support.
- `lib/features/guardians/`: Guardian management UI, list providers, add/delete dialogs.
- `lib/features/profile/`: User settings, terms, emergency info.
- `lib/features/shared/`: Shared UI components (`CalmButton`).

## Local Contracts

1. **State Management:**
   - Use `flutter_riverpod` exclusively (`ConsumerWidget`, `ConsumerStatefulWidget`, `AsyncNotifierProvider`).
   - Do not use `get_it` or secondary service locators in presentation layers.
2. **File & Component Size:**
   - Component and screen files should not exceed **300 lines**.
   - Modularize large screens (e.g. `MapScreen`) into dedicated sub-widgets (side menu, markers, sheet).
3. **Design System & UX Rules:**
   - Adhere strictly to "Serene Wave" tokens from `lib/app/theme/`.
   - Ensure touch targets are at least **60x60dp** for core interactive elements.
   - Docked SOS button in `MainShell` must remain reachable and never obscured by scrollable content.
4. **V.I.T.E. Visual & Video Standards:**
   - Maintain 60fps custom canvas animations for V, I, T, and an animated urgent countdown for E.
   - For video demonstrations (e.g., `incapacite.mp4`), ensure controllers are initialized asynchronously and properly disposed on screen unmount.
5. **Lifecycle & Memory Management:**
   - Always cancel stream subscriptions (`StreamSubscription`), timers, and dispose `AnimationController` / `VideoPlayerController` in `dispose()`.

## Work Guidance

- Place truly shared widgets in `lib/features/shared/` or `lib/app/widgets/`.
- Keep business logic in controllers/notifiers or core services, leaving widgets focused on declarative rendering.

## Verification

- Run `flutter test` for widget interactions and flow validation.
- Run `flutter analyze` to ensure lint compliance.

## Child DOX Index

- No child AGENTS.md files under `lib/features/`.
