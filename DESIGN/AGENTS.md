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

1. **Local-First Mandate:** All user health data and guardian configs persist exclusively in Hive local storage. No remote sync or cloud data collection is required.
2. **"Serene Wave" Visual Language:**
   - Deep Teal (`#006D77`), Soft Sage (`#83C5BE`), Warm Sand (`#EDF6F9`), Terracotta (`#E29578`), Deep Terracotta (`#BC4749`).
   - Font Pairings: `Outfit` (Headings) and `Inter` (Body).
   - High-contrast sunlight readability and minimum 60x60dp touch targets for accessibility.
3. **Emergency Priority:**
   - Primary: Immediate native dialing to SAMU (`185`).
   - Secondary: Direct WhatsApp 1-to-1 dispatch to primary guardian + native multi-recipient SMS broadcast fallback with GPS coordinates.
4. **V.I.T.E. Education:**
   - Real-time 60fps canvas/vector animations for V, I, T, and animated urgent countdown for E (4.5h window).
   - Optional local video modal demonstration for clinical symptom drill.

## Work Guidance

- When code and design documents diverge, treat the `DESIGN/` folder as the structural source of truth.
- Update `ARCHI.md` and `PRD.md` whenever core technical decisions (such as the 100% local persistence rule) are formalized.

## Verification

- Validate all UI layouts against `DESIGN/DESIGN_SYSTEM.md`.
- Ensure all architecture implementations align with `DESIGN/ARCHI.md`.

## Child DOX Index

- No child AGENTS.md files under `DESIGN/`.
