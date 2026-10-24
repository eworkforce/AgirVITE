# DESIGN DOX Contract

Durable guidance for product specifications, technical architecture, design system, and engineering standards for Agir V.I.T.E. 2.0.

## Purpose

Defines and maintains the authoritative product requirements, system architecture, "Serene Wave" visual system, and global development standards for Agir V.I.T.E. 2.0.

## Ownership

- `DESIGN/PRD.md`: Product scope, personas, clinical journeys, and functional requirements.
- `DESIGN/ARCHI.md`: Target technical architecture, 100% local-first data model, system contracts.
- `DESIGN/DESIGN_SYSTEM.md`: "Serene Wave" visual tokens, neomorphic surfaces, typography, and accessibility rules.
- `DESIGN/Global_Rules.md`: Engineering quality guidelines and priority order.
- `DESIGN/Addon-features.md`: Supplemental feature specifications and roadmap extensions.

## Local Contracts

1. **Local-First Mandate:** All user profile and guardian configs persist exclusively in Hive local storage. No Firebase, remote sync, or cloud data collection is used.
2. **Scope Removal (BP Tracker):** Blood Pressure (`Tension`) tracking and OCR have been completely removed from the app and navigation shell (`[Accueil, Centres] — (SOS) — [Guide, Conseils]`).
3. **"Serene Wave" Visual Language (100% Offline):**
   - Deep Teal (`#006D77`), Soft Sage (`#83C5BE`), Warm Sand (`#EDF6F9`), Terracotta (`#E29578`), Deep Terracotta (`#BC4749`).
   - Font Pairings: Bundled `Outfit` (Headings) and `Inter` (Body) in `assets/fonts/` with runtime fetching disabled.
   - High-contrast sunlight readability and minimum 60x60dp touch targets for accessibility.
4. **Emergency Priority:**
   - Primary: Immediate native dialing to SAMU (`185`).
   - Secondary: Direct WhatsApp 1-to-1 dispatch to primary guardian + native multi-recipient SMS broadcast fallback with GPS coordinates.
5. **V.I.T.E. Education:**
   - Bundled local videos (`master_visage_v.mp4`, `master_incapacite_i.mp4`, `master_trouble_t.mp4`, `master_urgence_e.mp4`) and `intro_vite_9x16.mp4` for V.I.T.E. symptom recognition and the 4h30 emergency window.

## Work Guidance

- When code and design documents diverge, treat the `DESIGN/` folder as the structural source of truth.
- Update `ARCHI.md` and `PRD.md` whenever core technical decisions are formalized.

## Verification

- Validate all UI layouts against `DESIGN/DESIGN_SYSTEM.md`.
- Ensure all architecture implementations align with `DESIGN/ARCHI.md`.

## Child DOX Index

- No child AGENTS.md files under `DESIGN/`.
