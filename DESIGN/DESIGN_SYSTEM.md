# **Design System: "Serene Wave"**

**Version:** 1.0.0
**Philosophy:** Calm Technology / "Assurance & Serenity"
**Target:** Flutter + Impeller (Mobile)
**Status:** Approved

---

## **1. Core Philosophy**

The interface acts as a co-regulator of the user's emotional state.
*   **No Alarmism:** Avoid aggressive reds (#FF0000). Use **Terracotta** for urgency.
*   **Tactile Assurance:** Controls should feel physical (Neomorphism) to provide confidence in actions.
*   **Contextual Focus:** Use Glassmorphism (blur) to isolate tasks (like SOS) without losing the background context.
*   **Connectivity Confidence:** Never alarm the user about network state. Treat "Offline" as a valid, safe state.

---

## **2. Color Palette**

### **Primary Brand**
| Name | Hex | Usage |
| :--- | :--- | :--- |
| **Deep Teal** | `#006D77` | Primary Headers, Brand Identity, Active Tab |
| **Soft Sage** | `#83C5BE` | Secondary Accents, Illustrations, Success background |
| **Warm Sand** | `#EDF6F9` | **App Background**, Card Surfaces (Light Mode) |

### **Functional & Status**
| Name | Hex | Usage |
| :--- | :--- | :--- |
| **Terracotta** | `#E29578` | High BP Alerts, Standard Urgency |
| **Deep Terracotta**| `#BC4749` | **SOS Button Border/Gradient** (Sunlight-Safe contrast) |
| **Forest Green** | `#2D6A4F` | Success, Normal BP Values |
| **Amber** | `#F9A825` | Warnings, Elevated BP |
| **Deep Charcoal**| `#121212` | Dark Mode Background, Primary Text (Light Mode) |

### **Text Hierarchy**
| Name | Hex | Usage |
| :--- | :--- | :--- |
| **Text Primary** | `#1D1D1D` | Headings, Body text (Light Mode) |
| **Text Secondary**| `#6B6B6B` | Captions, Subtitles, Hints |

---

## **3. Typography**

**Font Family:** `Outfit` (Headings) + `Inter` (Body)
*Fallback: Roboto (Android) / SF Pro (iOS)*

| Style | Weight | Size | Line Height | Usage |
| :--- | :--- | :--- | :--- | :--- |
| **Display Large** | Bold (700) | 32sp | 1.2 | Onboarding Slogans |
| **Heading H1** | SemiBold (600)| 24sp | 1.3 | Screen Titles |
| **Heading H2** | SemiBold (600)| 20sp | 1.3 | Card Titles |
| **Body Large** | Regular (400) | 18sp | 1.5 | Main Content (Elderly friendly) |
| **Body Medium** | Regular (400) | 16sp | 1.5 | Standard Text |
| **Button** | Bold (700) | 16sp | 1.0 | CTA Labels (Uppercased optional) |
| **Caption** | Light (300) | 12sp | 1.4 | Timestamps, Disclaimers |

---

## **4. UI Components & Effects**

### **4.1 Neomorphism (The "Calm Button")**
Used for primary interactions (SOS, Cards) to mimic physical buttons.

**Light Mode:**
*   **Shape:** Rounded Rect (Border Radius: 16px)
*   **Light Source:** Top-Left
*   **Shadow Light:** `-4px -4px 10px #FFFFFF` (Opacity 0.9)
*   **Shadow Dark:** `4px 4px 10px #BFC9CC` (Opacity 0.4)
*   **Surface:** `#EDF6F9` (Same as background)

**Dark Mode Strategy (Luminance-Based):**
*   *Neomorphic shadows fail on dark backgrounds.*
*   **Strategy:** Use surface overlays instead of shadows.
*   **Surface:** `#121212`
*   **Elevation 1:** Overlay White 5%
*   **Elevation 2:** Overlay White 8%
*   **Border:** 1px Solid `#2A2A2A`

### **4.2 Glassmorphism (The "Focus Layer")**
Used for Modals and Emergency Overlays.

**High-End Devices:**
*   **Blur:** `BackdropFilter` (Sigma X/Y: 10.0)
*   **Fill:** White with opacity `0.7`
*   **Border:** White with opacity `0.2` (1px width)

**Performance Fallback ("Lite" Mode):**
*   *For entry-level devices where blur causes jank.*
*   **Blur:** None (0.0)
*   **Fill:** Solid White (`#FFFFFF`) with opacity `0.95`
*   **Border:** Solid `#E5E5E5` (1px)

### **4.3 Cards (The "Bento" Unit)**
*   **Radius:** 20px
*   **Elevation:** Low (2px) for standard, High (8px) for active
*   **Padding:** 16px internal

---

## **5. Iconography & Assets**

*   **Style:** Rounded, Filled (Active) / Outlined (Inactive).
*   **Stroke Width:** 2px.
*   **Library:** Lucide or Phosphor Icons (Rounded).

---

## **6. Animation & Interaction (Rive)**

### **6.1 Haptic Feedback**
*   **Success:** `HapticFeedback.lightImpact()` (Single crisp tap)
*   **Warning:** `HapticFeedback.mediumImpact()` (Double pulse)
*   **Emergency/Error:** `HapticFeedback.heavyImpact()` (Deep vibration)

### **6.2 Rive State Machines**
All complex visuals must be Rive files (`.riv`) driven by State Machine Inputs.
*   **Inputs:**
    *   `isHover` (Bool)
    *   `isActive` (Bool)
    *   `level` (Number 0-100) - e.g., for BP Sliders
    *   `trigger` (Trigger) - e.g., on tap

---

## **7. Accessibility & Inclusivity**

### **7.1 Standards**
*   **Touch Targets:** Minimum **60x60dp** for all core actions (exceeds 48dp standard).
*   **Contrast:** Minimum 4.5:1 for text; 3:1 for graphical objects.
*   **Scale:** UI must respond to system font scaling up to 200%.

### **7.2 Sunlight-Safe SOS**
*   **Requirement:** Emergency button must be visible in direct equatorial sunlight.
*   **Implementation:** The SOS button uses a **Deep Terracotta (`#BC4749`)** stroke or subtle gradient border to ensure it stands out against the low-contrast "Warm Sand" background, even in glare.

### **7.3 Connectivity Confidence**
*   **Rule:** Never use alarming "No Connection" banners.
*   **Indicator:** Use a "Sync Pulse" in the header.
    *   🟢 **Green Dot:** Synced
    *   ⚪ **Hollow/Grey Dot:** Offline (Mode Hors-ligne - Data Saved Locally)
    *   🔄 **Spinning:** Syncing
