# Core Domain & Infrastructure DOX Contract

Durable guidance for domain models, repositories, hardware services, and local persistence.

## Purpose

Owns domain entities, local Hive repositories, hardware/system services (`EmergencyService`, `LocationService`), and shared utilities.

## Ownership

- `lib/core/models/`: Domain entities and data classes (`StrokeCenter`, `UserProfile`, `Guardian`).
- `lib/core/repositories/`: Local data access layer over Hive boxes and bundled assets.
- `lib/core/services/`: Hardware and system service integrations (`EmergencyService`, `LocationService`).
- `lib/core/utils/`: Shared helper functions and formatters (`PhoneNumberFormatter`, `VideoAssetHelper`).

## Local Contracts

1. **Model Standardization:**
   - All domain models must use `@freezed` + `@HiveType` + `json_serializable` (or Hive `TypeAdapter`).
   - Hive Type IDs: `0` (retired/reserved, formerly `BPReading`), `StrokeCenter: 1`, `UserProfile: 2`, `Guardian: 3`.
   - Never reuse retired Type ID `0`, mutate existing Type IDs, or re-order field indices casually.
2. **Persistence Rules:**
   - 100% local-first storage using Hive.
   - Do not add remote cloud sync dependencies or external storage hooks.
3. **Emergency Service (`EmergencyService`):**
   - `findClosestCenter(centers, position)` computes the closest `StrokeCenter` using GPS coordinates (or defaults to Abidjan `5.340277, -4.013233` if GPS is unavailable).
   - `callCenter(phoneNumber)` invokes native Android `callNumberDirectly` (`ACTION_CALL`) via `MethodChannel('com.avcespoir.agir_vite/emergency')` with `tel:` URI fallback.
   - `sendHeadlessSms(phoneNumber, ...)` invokes native Android `sendDirectSms` (`SmsManager.sendMultipartTextMessage`) via `MethodChannel('com.avcespoir.agir_vite/emergency')` to send the emergency SMS automatically and headlessly in the background to the First Contact.
   - `sendWhatsAppAlert(phoneNumbers, ...)` uses `whatsapp://send?phone=225...&text=...` (with `https://wa.me/225...` fallback) pre-addressed to the First Contact's normalized phone number so no manual recipient selection is required.
4. **Location & Resource Safety:**
   - Streams from `LocationService` must be cancellable and safe for single-frame or continuous GPS polling.

## Work Guidance

- Keep domain repositories and services cleanly decoupled from Flutter UI widgets and presentation state.
- Run code generation (`dart run build_runner build --delete-conflicting-outputs`) after any model change.

## Verification

- Write unit tests under `test/` for all services and repositories.
- Verify zero static analysis issues via `flutter analyze`.

## Child DOX Index

- No child AGENTS.md files under `lib/core/`.
