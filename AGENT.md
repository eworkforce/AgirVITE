# AGENT.md

Repository guidance for AI agents working on Agir V.I.T.E. 2.0.

## Project Identity

Agir V.I.T.E. is a Flutter application for stroke prevention, blood pressure monitoring, education, and emergency response in Cote d'Ivoire. Treat it as a health-adjacent, emergency-sensitive app: reliability, offline behavior, privacy, and calm UX matter more than visual novelty.

The product direction is defined in `DESIGN/`:

- `DESIGN/PRD.md`: product scope, personas, journeys, and success metrics.
- `DESIGN/ARCHI.md`: target architecture and offline-first principles.
- `DESIGN/DESIGN_SYSTEM.md`: "Serene Wave" visual language.
- `DESIGN/Global_Rules.md`: engineering rules and priority order.

The current implementation is a working Flutter prototype that partially implements those docs. When docs and code differ, document the mismatch in your response and make the smallest change that moves the code toward the documented architecture.

## Current Stack

- Flutter app package: `agir_vite`
- Dart SDK constraint: `^3.10.3`
- State management: `flutter_riverpod` with manual providers and `AsyncNotifierProvider`
- Routing: `go_router`
- Local persistence: Hive / Hive Flutter
- Data classes: Freezed plus JSON serialization and Hive adapters
- Backend dependencies: Firebase Core/Auth/Firestore/Functions/Storage
- OCR: `google_generative_ai`, configured via `flutter_dotenv`
- Maps: `flutter_map`, `latlong2`, `geolocator`
- Media: `camera`, `image_picker`, `video_player`
- UI assets: local images, `assets/data/stroke_centers.json`, and `assets/videos/incapacite.mp4`

## Verified Commands

Use these from the repository root:

```bash
flutter pub get
flutter analyze
flutter test
dart run build_runner build --delete-conflicting-outputs
dart format .
flutter build apk --debug
flutter build apk --release
```

Last local verification:

- `flutter analyze`: passed with no issues.
- `flutter test`: failed because `test/widget_test.dart` expects `AVC\nESPOIR`, while `lib/features/onboarding/screens/brand_screen.dart` currently renders `V.I.T.E`. `test/widget/onboarding_flow_test.dart` passed its two tests during the same run.
- Dependency note: `flutter pub get` reports one discontinued package, `flutter_map_cancellable_tile_provider`, and many constrained outdated packages. Do not upgrade broad dependency families without a focused migration plan.

## Repository Structure

Main source directories:

- `lib/main.dart`: initializes Flutter bindings, Hive, adapters, boxes, Firebase, and `ProviderScope`.
- `lib/app/`: app shell, theme, and router.
- `lib/app/theme/`: central colors, typography, and `ThemeData`.
- `lib/core/models/`: Freezed/Hive models for BP readings, stroke centers, and user profile.
- `lib/core/repositories/`: local repositories over Hive and asset data.
- `lib/core/services/`: OCR, BP tracker, emergency, and location services.
- `lib/data/local/boxes/hive_boxes.dart`: canonical Hive box names.
- `lib/features/`: feature-first UI and providers.
- `test/`: widget tests.
- `scripts/`: APK distribution helpers.
- `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/`: platform projects.

Current feature slices:

- `onboarding`: brand, pledge, reflex drill, profile setup.
- `dashboard`: home screen and BP status card.
- `emergency`: long-press SOS button.
- `bp_tracker`: camera capture and reading review.
- `vite_guide`: educational V.I.T.E. screens.
- `map`: stroke center map and details sheet.
- `stories`: video/story feed.
- `guardians`: Guardian model, repository, and list provider.
- `profile`: user profile screen/provider.
- `shared`: reusable calm button.

## Architecture Rules

Follow the existing feature-first organization. Shared domain models, repositories, and device/API services currently live under `lib/core`; feature-specific UI and providers live under `lib/features/<feature>`.

Preserve the app's offline-first direction:

- Write user health data to Hive first.
- Treat Firebase/network behavior as sync or enhancement unless the task explicitly changes that contract.
- Keep emergency call behavior independent from location, WhatsApp, Firebase, or internet availability.
- Do not block SAMU dialing on a recoverable secondary failure.

Use Riverpod consistently:

- Existing code uses manual providers, `Provider`, `StreamProvider`, and `AsyncNotifierProvider`.
- Do not introduce a second dependency injection framework for new code. `get_it` is in `pubspec.yaml`, but the current implementation is Riverpod-centered.
- If adding generated Riverpod providers, make the migration local and run build runner.

Use Freezed/Hive carefully:

- Source models are in `*.dart`; generated `*.freezed.dart` and `*.g.dart` must not be edited manually.
- Existing Hive type IDs are:
  - `BPReading`: `0`
  - `StrokeCenter`: `1`
  - `UserProfile`: `2`
  - `Guardian`: `3`
- Do not reuse Hive type IDs or change field indexes casually. Treat those changes as data migrations.

## Critical Flows

Emergency SOS:

- `lib/features/emergency/widgets/sos_button.dart` performs a two-second press and calls `EmergencyService`.
- `lib/core/services/emergency_service.dart` launches `tel:185` and sends a WhatsApp message.
- The phone call must remain the first critical action. Location and WhatsApp alerting are secondary.
- If adding error handling, keep it recoverable and user-safe; do not turn a failed location lookup into a failed emergency call.

Blood pressure capture:

- `CaptureScreen` owns camera lifecycle and sends captured image paths to `OCRService`.
- `OCRService` reads `GEMINI_API_KEY` from dotenv and currently returns demo fallback values when Gemini/key/parsing fails.
- `ReviewScreen` lets the user validate/edit values and saves through `BPTrackerService`.
- Avoid saving OCR output without user confirmation.
- Prefer explicit validation ranges for systolic, diastolic, and pulse before expanding this feature.

Onboarding and routing:

- Router starts at `/onboarding/brand`.
- `BrandScreen` routes complete users to `/dashboard`; incomplete users continue to `/onboarding/pledge`.
- Do not reintroduce automatic redirects that skip the brand screen unless the product requirement changes.
- Tests around onboarding are sensitive to infinite animations; use timed `pump` where needed instead of unconditional `pumpAndSettle`.

Map and centers:

- Stroke center data loads from `assets/data/stroke_centers.json`.
- `MapScreen` currently uses live OpenStreetMap raster tiles, despite docs targeting offline vector maps.
- Treat true offline maps as unfinished. Do not claim this feature is fully offline until tile storage/rendering is implemented.

## Design Rules

Use the "Serene Wave" system:

- Primary palette comes from `lib/app/theme/colors.dart` and `DESIGN/DESIGN_SYSTEM.md`.
- Avoid alarmist pure red. Use the app's emergency/terracotta colors for urgency.
- Core touch targets should be large and readable for older users.
- The app language is French-first for user-visible health flows.
- Do not add decorative UI that competes with emergency, education, or monitoring tasks.

For frontend changes:

- Reuse existing theme and shared widgets before creating new visual styles.
- Keep dashboard/action surfaces scannable and touch-friendly.
- Test small screens and text scaling for health-critical copy.
- Keep SOS visible and reachable; avoid overlapping it with scrollable content.

## UI/UX Review Map

Use this map before incremental UI review work. It reflects the current routed Flutter implementation plus the intended UX architecture from `DESIGN/PRD.md` and `DESIGN/ARCHI.md`.

Current UI pages and major components:

- `/onboarding/brand` - `BrandScreen`: brand/welcome entry with V.I.T.E. pulse, slogan, AVC Espoir logo, and continue CTA. This also behaves as the splash/welcome page after onboarding.
- `/onboarding/pledge` - `PledgeScreen`: campaign pledge with "S'INFORMER, PRÉVENIR ET AGIR VITE" and offline reassurance.
- `/onboarding/reflex` - `ReflexDrillScreen`: two-second SOS long-press practice to build emergency muscle memory.
- `/onboarding/profile` - `ProfileSetupScreen`: user first name plus first emergency guardian; completes onboarding and routes to dashboard.
- `/dashboard` - `DashboardScreen`: main welcome/home page with greeting, BP status, four action cards, and floating SOS.
- `BPStatusCard`: dashboard health summary showing latest BP reading, status badge, optional trend/chart, and recommendation.
- `SOSButton`: persistent long-press emergency affordance; calls SAMU and sends WhatsApp alert.
- `/bp-tracker/capture` - `CaptureScreen`: camera OCR flow for framing and capturing a BP monitor image.
- `/bp-tracker/review` - `ReviewScreen`: user validates/edits systolic, diastolic, and pulse values before saving.
- `/vite-guide` - `ViteGuideScreen`: tabbed V.I.T.E. education shell with V/I/T/E tabs.
- `VisageScreen`: V.I.T.E. face symptom education using crossfade image animation.
- `IncapaciteScreen`: V.I.T.E. arm weakness education using looping video.
- `TroubleScreen`: V.I.T.E. speech trouble education; currently less complete than Visage/Incapacité.
- `EnUrgenceScreen`: V.I.T.E. time/emergency education; prompts immediate SAMU 185 action.
- `/map` - `MapScreen`: stroke center map, user location, center markers, nearest-center logic, side menu.
- `CenterDetailsSheet`: selected center bottom sheet with scanner badge, address, navigation, and call actions.
- `/stories` - `StoriesFeedScreen`: vertical video/story feed; currently prototype/mock remote videos.
- `/profile` - `ProfileScreen`: profile, guardians list, add/delete guardian dialogs, app info/privacy entries.
- `CalmButton`: tactile primary/secondary shared button used in setup and map actions.

UX architecture zones:

- Onboarding / Trust Setup: brand immersion -> pledge -> SOS drill -> profile and guardian setup. Purpose: establish trust, teach the emergency gesture, and collect minimum safety data.
- Dashboard / Daily Hub: personalized greeting, latest BP status, four primary actions, persistent SOS. Purpose: one-screen access to prevention, learning, care locations, content, and emergency.
- Core pillars: `Savoir` is the V.I.T.E. guide, `Agir` is BP capture/review/status, `Réagir` is SOS/SAMU/guardian alert, and `Soutien` is map, stories, profile, and guardians.
- Emergency overlay principle: SOS is not just a page; it is a persistent critical action. It must remain visible, reachable, and unblocked by secondary flows.

Important UI review checkpoints:

- Dashboard first viewport: verify hierarchy, SOS position, card density, and text readability on real devices.
- Onboarding continuity: Brand -> Pledge -> Reflex -> Profile should feel like one guided story rather than separate forms.
- V.I.T.E. consistency: `TroubleScreen` and `EnUrgenceScreen` need parity with the more polished `VisageScreen` and `IncapaciteScreen`.
- BP flow safety: OCR values must always be reviewed before save; validation ranges for SYS/DIA/PULSE need review.
- Emergency flow: SAMU call must remain primary; guardian/location/WhatsApp behavior is secondary and must not block dialing.
- Map claim: current map uses online OSM tiles, so do not present it as fully offline until offline tile storage/rendering exists.
- Stories: current feed is prototype content, not final production content architecture.

## Security And Privacy

- Never hardcode secrets. `GEMINI_API_KEY` belongs in `.env` or platform-specific secure configuration.
- Do not log health readings, phone numbers, locations, API keys, or raw OCR images.
- Be careful with Firebase config and Storage upload scripts. Public Firebase config is not a secret, but service credentials and tokens are.
- Emergency messages include location; treat this as sensitive user data.
- Ask before changing Android/iOS permissions or URL schemes.

## Known Gaps And Risks

- `flutter test` has one stale expectation in `test/widget_test.dart`.
- `lib/features/map/screens/map_screen.dart` is 534 lines and should be split before major map work.
- The target architecture mentions Firebase sync, offline queueing, and ML Kit fallback; current code is mostly local Hive plus Firebase initialization, with no visible sync queue implementation.
- OCR fallback returns plausible demo values, which is unsafe for production health behavior. Future work should surface manual entry or an explicit "unreadable" state instead.
- `EmergencyService.callSAMU()` throws a string on launch failure; prefer typed exceptions or result objects for user-facing recovery.
- `sendWhatsAppAlert` accepts guardian phone numbers but currently uses a generic share URL instead of targeting contacts.
- `MapScreen` subscribes to a location stream without storing/canceling the subscription; watch for lifecycle leaks when editing it.
- Several docs still refer to `docs/`, but this repository uses `DESIGN/`.

## Testing Expectations

Before finalizing code changes:

- Run `flutter analyze`.
- Run focused tests for changed areas, then `flutter test` when feasible.
- Run `dart run build_runner build --delete-conflicting-outputs` after model/provider serialization changes.
- Run `dart format .` after Dart edits.

For new or changed behavior:

- Repository/service changes need unit tests where possible.
- Critical UI flows need widget tests, especially onboarding, SOS, BP review, and map center selection.
- Emergency behavior should be tested so a secondary failure does not block the primary call path.

## Agent Workflow

1. Read `DESIGN/Global_Rules.md`, `DESIGN/ARCHI.md`, and the files directly related to the task.
2. Check existing patterns with `rg` before editing.
3. Keep changes atomic and scoped to the request.
4. Prefer fixing code toward the documented architecture over expanding ad hoc behavior.
5. Do not edit generated files manually.
6. Do not revert unrelated work. This repo may contain untracked local agent skill files.
7. Report verification honestly, including any existing failures that were not caused by your change.
