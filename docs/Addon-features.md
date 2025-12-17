# Future Feature Brainstorming & Enhancements

This document captures potential features and enhancements for future iterations of Agir V.I.T.E., derived from brainstorming sessions based on the core architectural pillars (Savoir, Agir, Réagir).

## 1. Pillar: SAVOIR (The V.I.T.E. Guide)

*   **"Smart Audio" Auto-Fallback**
    *   **Concept:** Detect device volume or headphones. Auto-play audio if headphones connected; pulse subtitles if volume is zero.
    *   **Why:** Ensures accessibility regardless of environment or literacy without startling the user.

*   **The "Mirror" Check (Visage)**
    *   **Concept:** Button to open front camera (no recording) in the "Visage" guide section.
    *   **Why:** Allows immediate real-time comparison between the Rive animation and the victim's face.

*   **"Drill Maintenance" Notification**
    *   **Concept:** Monthly notification to practice the "Reflex Drill" (2s SOS Long Press).
    *   **Why:** Maintains muscle memory for emergency situations.

## 2. Pillar: AGIR (BP Tracker)

*   **"Context Tags" for Readings**
    *   **Concept:** Single-tap tags for readings: "Morning", "Evening", "Before Meds", "After Meds".
    *   **Why:** Adds clinical context to raw BP values for doctor review.

*   **The "Phantom" Guide (Manual Entry)**
    *   **Concept:** Translucent overlay of a generic BP monitor over manual entry fields.
    *   **Why:** Reduces cognitive load by visually mapping inputs to physical device layout.

*   **"Trend" Haptics**
    *   **Concept:** Subtle haptic ticks when scrubbing chart data points; heavier feedback for high BP zones.
    *   **Why:** Reinforces health data through tactile feedback.

## 3. Pillar: RÉAGIR (Emergency)

*   **The "Guardian Handshake"**
    *   **Concept:** Generate a specific "Welcome" WhatsApp message when a Guardian is first added.
    *   **Why:** Prepares the guardian to recognize and trust future emergency alerts.

*   **"Offline Bearing" (Maps)**
    *   **Concept:** Display a "compass bearing" line to the nearest center when turn-by-turn routing is unavailable offline.
    *   **Why:** Provides actionable direction in rural areas without relying on online map servers.

## 4. General UX & Architecture

*   **"Dusk/Dawn" Transition Animations**
    *   **Concept:** Slow cross-fade of gradient backgrounds based on time of day (sun position).
    *   **Why:** Enhances "Calm Technology" feel; makes the app feel organic.

*   **"Sync" Heartbeat**
    *   **Concept:** Subtle visual pulse when offline data successfully syncs to Firebase.
    *   **Why:** Non-intrusive reassurance of data backup.
