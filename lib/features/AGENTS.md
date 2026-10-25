# Features Presentation DOX Contract

Durable guidance for presentation slices, UI screens, widgets, animations, and Riverpod providers.

## Purpose

Owns all feature-first presentation code, screen flows, widget hierarchies, visual animations, and Riverpod state notifiers.

## Ownership

- `lib/features/onboarding/`: Onboarding flow (`IntroVideoScreen`, `BrandScreen`, `PledgeScreen`, `ReflexDrillScreen`, `ProfileSetupScreen`) and `OnboardingProgressHeader` (`Étape 1..3 sur 3` + back navigation).
- `lib/features/dashboard/`: Main dashboard with personalized greeting and 2x2 V.I.T.E. emergency signs grid.
- `lib/features/emergency/`: Persistent `SOSButton` (2-second hold navigating to `/map?emergency=true`), `EmergencyMapOverlay`, and `showExternalActionConfirmOverlay`.
- `lib/features/vite_guide/`: Tabbed educational module (`VisageScreen`, `IncapaciteScreen`, `TroubleScreen`, `EnUrgenceScreen`) with local `master_*.mp4` videos.
- `lib/features/map/`: Stroke center map (`MapScreen`), marker widget (`CenterMapMarker`), slide-out menu (`MapSideMenu`), location marker (`UserLocationMarker`), and `CenterDetailsSheet`.
- `lib/features/stories/`: Interactive Recto/Verso 3D Flip-Card Prevention Hub (`StoriesFeedScreen`, `PreventionFlipCard`, and `StrokePreventionData`).
- `lib/features/guardians/`: Contact (`Guardian`) model, repository, and list providers. User-facing terminology is strictly `"Contact"` / `"Premier contact"` / `"Contacts d'urgence"` (never `"Gardien"`).
- `lib/features/profile/`: User profile and emergency contact management dialogs (`ProfileScreen`).
- `lib/features/shared/`: Shared UI components (`CalmButton`, `ViteVideoPlayer`, `ViteVideoTheaterModal`).

## Local Contracts

1. **State Management:**
   - Use `flutter_riverpod` exclusively (`ConsumerWidget`, `ConsumerStatefulWidget`, `AsyncNotifierProvider`).
   - Do not use secondary service locators in presentation layers.
2. **File & Component Size:**
   - Component and screen files must not exceed **300 lines** (excluding imports/comments).
   - Modularize screens into dedicated sub-widgets (`map_side_menu.dart`, `center_map_marker.dart`, `emergency_map_overlay.dart`, `external_action_confirm_dialog.dart`, `onboarding_progress_header.dart`).
3. **Design System & UX Rules:**
   - Adhere strictly to "Serene Wave" tokens from `lib/app/theme/` with bundled offline `Outfit` and `Inter` fonts (`GoogleFonts.config.allowRuntimeFetching = false`).
   - Ensure touch targets are at least **60x60dp** for core interactive elements.
   - Docked SOS button in `MainShell` (`[Accueil, Centres] — (SOS) — [Guide, Conseils]`) navigates to `/map?emergency=true`, zooms onto the closest stroke center, automatically calls that center, and dispatches headless background SMS + WhatsApp to the First Contact.
   - Use `"Premier contact"` / `"Contact"` in all UI labels instead of `"Gardien"`.
4. **V.I.T.E. Video Standards:**
   - Use `ViteVideoPlayer` and `VideoAssetHelper` for bundled `assets/videos/master_*.mp4` assets, with `ViteVideoTheaterModal` for native landscape fullscreen playback.
   - Ensure video controllers are initialized asynchronously and properly disposed on screen unmount.
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
