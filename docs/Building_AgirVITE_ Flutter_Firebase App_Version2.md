# **Strategic Technical Blueprint: Agir V.I.T.E. 2.0**

Engineering a Digital Lifeline for Stroke Prevention in Côte d'Ivoire  
Consolidated Report: Original Vision \+ AI/Resilience Updates  
Author: ONG AVC Espoir & Technical Team  
Date: December 2025

## **Abstract**

The "Agir V.I.T.E." mobile application represents a pivotal technological intervention within the national sensitization campaign orchestrated by ONG AVC Espoir. This document serves as the comprehensive strategic dossier for Version 2.0. It preserves the foundational "Calm Technology" vision while integrating advanced 2025 capabilities: a **State Machine-First animation workflow (Rive)**, a **Hybrid AI-OCR engine (Google Gemini)**, and a prioritized **WhatsApp communication protocol**. This blueprint balances high-fidelity UX for Abidjan with rugged offline resilience for rural localities.

## **1\. Executive Strategy and Digital Vision**

The application must function not merely as a repository of information but as an active, intelligent, and empathetic partner. The mission to reduce the morbidity and mortality associated with Cerebrovascular Accidents (CVA) demands a digital product that transcends conventional boundaries. It requires a sophisticated, "Offline-First" ecosystem that offers "assurance and serenity" through "Calm Technology" while executing high-stakes emergency protocols.

### **1.1 The Public Health Imperative**

The backdrop is a "silent health crisis" of staggering proportions. With hypertension prevalence estimated at nearly 40% among adults, the risk environment is ubiquitous. The Terms of Reference (TDR) identify a "massive deficit of knowledge" and a lack of "reflex response" as primary barriers.

The infrastructure presents specific constraints that dictate the architecture:

* **Connectivity Intermittency:** The app must be fully functional offline (2G/No Data).  
* **Device Fragmentation:** From high-end iPhones to entry-level Android devices (Tecno, Infinix).  
* **Data Sensitivity:** Counteracting "white coat syndrome" through a soothing UI.

### **1.2 Strategic Pillars: Savoir, Agir, Réagir**

1. **SAVOIR (Knowledge):** Demystifying the disease. Transforming medical concepts into accessible content.  
2. **AGIR (Prevention):** Transitioning from passive reading to active monitoring (BP tracking) to sustain engagement.  
3. **RÉAGIR (Emergency):** A friction-free protocol to connect the user with assistance within the "Golden Hour."

## **2\. User Experience (UX) Architecture: Designing for Serenity**

The directive to create an experience of "assurance and serenity" necessitates a radical departure from traditional emergency app aesthetics (red/yellow alarms).

### **2.1 The Philosophy of Calm Health UX**

The UX must act as a co-regulator of the user's emotional state. Through progressive disclosure, the interface communicates stability. The emergency protocol is omnipresent but not intrusive—a "break glass in case of emergency" affordance.

* **Oversized Tap Targets:** Minimum 60x60 logical pixels for emergency actions.  
* **Gesture-Based Navigation:** Simple swipes rather than precision taps.  
* **Forgiving Design:** "Slide to Call" to prevent accidental SOS triggers.

### **2.2 Visual Identity: "Serene Wave" Design System**

**Color Psychology**

* **Primary \- Deep Teal (\#006D77):** Authority without coldness.  
* **Secondary \- Soft Sage (\#83C5BE) & Warm Sand (\#EDF6F9):** Organic calm.  
* **Action/Emergency \- Terracotta (\#E29578):** Replaces "Warning Red" (\#FF0000). Urgent but grounded, avoiding cortisol spikes.  
* **Dark Mode:** Deep charcoal (\#121212) for battery conservation.

Neomorphism and "Soft UI"  
To meet the requirement for a "stunning UI," the design leverages a refined version of Neomorphism combined with Glassmorphism.

* **Tactile Interfaces:** The SOS button appears extruded from the surface with soft lights/shadows, inviting physical interaction.  
* **Glassmorphism:** Modal alerts use frosted glass effects (background blur) to focus attention without losing context.

### **2.3 Rive State Machine Workflow (Design-to-Code)**

*Note: This section details the advanced animation workflow requested for Version 2.0.*

To achieve fluid interactivity on fragmented Android devices, we move from code-driven animation to a **State Machine-driven workflow**.

* **Strategy:** We utilize fully pre-designed animated assets with embedded logic. The logic (Idle, Loading, Success, Error) is defined by the designer inside the Rive editor, not in the Flutter code.  
* **Implementation:** The Flutter developer uses StateMachineController to simply trigger Inputs (Booleans/Numbers).  
* **Benefit:** This eliminates "spaghetti code" and ensures the complex "Serene Wave" animations run at 60fps via the Impeller engine.

### **2.4 Inclusive Design**

* **Voice-First Interface:** Critical text blocks will feature audio guidance recorded by empathetic voice actors.  
* **Animated Iconography:** Concepts like "Facial Drooping" are communicated through Rive animations rather than static text.  
* *Roadmap Note:* Support for local languages (Baoulé, Dioula, Bété) is scheduled for the Phase 2 evolution (post-launch). Version 1 will focus on French.

## **3\. Technical Architecture: Flutter & Firebase**

### **3.1 Framework Selection: Flutter & Impeller**

Flutter is the unequivocal choice. We will strictly enable the **Impeller rendering engine** (now default/opt-in on Android) to eliminate shader compilation jank. This is non-negotiable for delivering smooth Neumorphic visuals on mid-range devices.

### **3.2 Backend Strategy: Offline-First**

* **Firestore:** Architected for offline persistence. Reads come from the local cache; writes are queued.  
* **Cloud Functions:** For secure backend logic (WhatsApp API triggers, data aggregation).  
* **State Management:** Riverpod \+ Clean Architecture for maintainable, testable code.

## **4\. Core Feature Specification**

### **4.1 The "V.I.T.E." Interactive Guide (Savoir)**

Instead of a static checklist, we implement an Interactive Diagnostic Companion using Rive.

* **Visage:** User toggles a slider; the avatar transitions from a smile to a drooping face (visual cause-and-effect).  
* **Incapacité:** User taps to raise arms; the avatar visualizes one arm drifting down.

### **4.2 Emergency Response Engine (Réagir)**

*Updated Protocol: Hybrid Medical & Social Response.*

1. **Immediate Medical Action (Native Call):** Upon triggering the SOS, the app **immediately invokes the native dialer** with the SAMU number (**185**) pre-filled. This ensures the fastest possible connection to medical authorities, regardless of data connectivity.  
2. **Guardian Notification (WhatsApp):** Simultaneously, for the "Cercles de Vie" (Social Health Guardians), the app triggers a pre-filled **WhatsApp message**. This message includes the timestamp and the **Plus Code** location (e.g., "SOS \- Stroke Alert \- Location: 6QJ4+2X Abidjan") to guide family members to the victim.  
3. **Secondary Guardian Channel (SMS):** While SMS is critical for contacting guardians in 2G zones, full background SMS broadcasting is scheduled for the **Next Iteration (Phase 2\)**. Version 1 relies on WhatsApp for guardian alerts and the Native Call for SAMU.  
4. **Geolocation:** Instant capture using geolocator. Conversion to Plus Codes for precise offline addressing.

### **4.3 Intelligent Hypertension Tracker (Agir)**

*Updated Technology: Hybrid AI-OCR.*

We replace the legacy ML Kit implementation with a modern **Hybrid AI Strategy** to accurately read 7-segment digital BP monitors.

* **Primary Engine (Google Gemini 1.5 Flash):** The app sends the image to Gemini (Multimodal model). Prompt engineering enforces a JSON output {"sys": 120, "dia": 80}. This solves the "glare" and "digital 8 vs 0" issues common in standard OCR.  
* **Fallback:** If offline, the app reverts to local ML Kit with a "Review Mode" for user verification.  
* **Visualization:** Data is plotted on animated charts using fl\_chart.

### **4.4 Offline Mapping**

Usage of flutter\_map with vector\_map\_tiles. A compressed vector map of Côte d'Ivoire allows users to locate stroke centers (with CT Scanners) completely offline.

## **5\. Advanced Features & "The Extra Mile"**

### **5.1 "Cercles de Vie" (Circles of Life) \- Social Health**

Status: Core Feature (Gold).  
Allows a primary user to invite "Guardians." If the SOS is triggered, or if adherence drops, Guardians are notified. This leverages the communal culture of Ivorian society.

### **5.2 Audio-Visual "Stories" Feed**

Status: Core Feature.  
A TikTok-style feed of short vertical videos (Doctors explaining signs, Survivors sharing hope). Cached locally for offline playback.

### **5.3 Features Scheduled for Future Roadmap (Post-V1)**

* **Gamification & Rewards (Orange/MTN):** While innovative, the technical integration with MNOs is complex ("Avant-gardist"). Moved to future evolution.  
* **Relaxation Mode:** The breathing exercise feature is labeled "Nice to have" for future updates.

## **6\. UI/UX Design Specifications**

### **6.1 Onboarding: The "Hand-Holding" Experience**

*Revised Flow based on updated requirements.*

**Screen 1: Brand Immersion**

* **Visual:** A full-screen, high-resolution background image featuring the **AVC Espoir Logo**.  
* **Animation:** A pre-designed "Gentle Pulse" animation layer on top of the logo to signify life and calm. No complex Rive heart yet, just strong branding.

**Screen 2: The Pledge**

* **Slogan:** "Contre l'AVC, S'INFORMER, PREVENIR ET AGIR VITE, pour sauver des Vies."  
* **Context:** Explains that the app is a private, offline-capable tool.

**Screen 3: The Reflex**

* **Action:** Interactive drill. User must practice the "Long Press" on the SOS button to build muscle memory before entering the app.

### **6.2 The Dashboard (Home) Layout**

A "Bento Box" grid layout (modular cards) is the trend for 2025\.

* **Header:** "Bonjour, \[Name\]." Background changes color subtly based on the time of day (Dawn, Day, Dusk, Night).  
* **Top Card (Large):** "Statut Actuel." Displays the last BP reading with a color-coded rim.  
* **Action Row:**  
  * **Card 1:** "Prendre ma tension" (Icon: Camera/OCR).  
  * **Card 2:** "Urgence V.I.T.E." (Icon: Warning Triangle).  
* **Floating Action Button (FAB):** The Emergency Button floats above all content, anchored at the bottom center, ensuring it is reachable with a thumb.

### **6.3 Accessibility Features**

* **Dynamic Type:** Support for large text sizes for elderly users.  
* **High Contrast Mode:** A toggle for users with visual impairments.  
* **Haptic Feedback:** Distinct vibration patterns for success (light tap), warning (double tap), and emergency (heavy vibration).

## **7\. Implementation Roadmap & Governance**

The roadmap has been reordered to prioritize the core "Savoir" and "Réagir" pillars while accommodating the technical integration of Gemini and WhatsApp.

**Phase 1: The Core Foundation (Months 1-3)**

* **Focus:** MVP (Minimum Viable Product) with Core "V.I.T.E." and "Réagir".  
* **Deliverables:**  
  * Flutter project setup with Clean Architecture, Riverpod, and **Impeller**.  
  * Firebase Authentication (Anonymous \+ Phone).  
  * **Interactive V.I.T.E. Guide** (Rive State Machines implementation).  
  * **Emergency Protocol:** Native Call (185) \+ WhatsApp (Guardians).  
  * **Onboarding Flow 2.0** (Brand Immersion \+ Reflex Drill).  
* **Goal:** A functional app that can educate users and save a life immediately.

**Phase 2: Intelligence & Data (Months 3-5)**

* **Focus:** The "Agir" axis (Prevention and Monitoring).  
* **Deliverables:**  
  * **Hybrid AI-OCR Tracker:** Integration of Gemini 1.5 Flash for BP monitor reading (with ML Kit fallback).  
  * **Data Visualization:** fl\_chart implementation for health trends.  
  * **Offline Mapping:** Integration of flutter\_map \+ vector tiles for locating stroke centers.  
  * **Stories Feed:** Video player with local caching.  
* **Goal:** A daily utility tool for hypertensive patients.

**Phase 3: Resilience & Hardening (Months 5-7)**

* **Focus:** Connectivity hardening and language expansion (Post-Launch V1.1).  
* **Deliverables:**  
  * **Background SMS Integration:** Implementing the fallback channel for Guardians in 2G zones.  
  * **Local Languages Audio:** Recording and integrating Baoulé, Dioula, and Bété voiceovers.  
  * **Field Testing:** Stress-testing offline capabilities in rural zones (e.g., Korhogo).  
* **Goal:** Ensuring the app reaches the most vulnerable populations.

**Phase 4: Future Evolution (Year 1+)**

* **Focus:** Ecosystem and Engagement.  
* **Deliverables:**  
  * **Gamification:** Integration with Orange/MTN APIs for data rewards.  
  * **Relaxation Mode:** Breathing exercises.  
  * **Gemini Nano Migration:** Moving AI processing fully on-device as hardware allows.

## **8\. Summary of Technical Recommendations**

The following table summarizes the key technical decisions to ensure the app meets its ambitious goals, updated for Version 2.0 requirements.

| Feature Area | Recommended Technology / Package | Strategic Justification |
| :---- | :---- | :---- |
| **Framework** | **Flutter (Dart) \+ Impeller** | Best-in-class rendering (60fps), cross-platform, vibrant ecosystem. Impeller is mandatory for Rive performance. |
| **Backend** | **Firebase** (Firestore, Auth, Functions) | Robust offline sync, scalable, fast time-to-market. |
| **Local Database** | **Hive or Isar** | Faster than SQLite, NoSQL, perfect for caching data offline. |
| **Mapping** | **flutter\_map \+ vector\_map\_tiles** | Enables full offline mapping without data costs or API fees. |
| **Animations** | **Rive (State Machines)** | Interactive, lightweight vector animations. State Machines move logic from code to design, reducing bugs. |
| **Charts** | **fl\_chart** | Beautiful, animated charts for health data visualization. |
| **OCR (AI)** | **Gemini 1.5 Flash** (+ ML Kit Fallback) | **Gemini:** Superior accuracy for 7-segment displays. **ML Kit:** Ensures function in total offline mode. |
| **State Mgmt** | **Riverpod** | Compile-time safety, testable, robust state handling. |
| **Emergency** | **geolocator, url\_launcher** | Core plugins for location and invoking Native Call (185) & WhatsApp (Guardians). |

## **9\. Conclusion**

The "Agir V.I.T.E." application is poised to set a new benchmark for digital health interventions in West Africa. By harmonizing the medical urgency of stroke prevention with the empathetic principles of Calm Technology, and backing it with a rugged, offline-first technical architecture, AVC Espoir can offer the Ivorian population a tool that is not only functional but deeply trusted.

The integration of cutting-edge features like **Gemini AI-driven OCR** and **WhatsApp-First alerts** demonstrates a commitment to quality and accessibility, ensuring that no user is left behind due to literacy or connectivity barriers. This blueprint provides the roadmap to transform the vision of "Agir V.I.T.E." into a tangible, life-saving reality—a digital guardian in the pocket of every Ivorian.