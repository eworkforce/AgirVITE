---

title: Product Requirements Document (PRD)  
version: 2.0.0  
status: Draft  
author: [Author Name]  
date:

# **Context Links**

## **global_rules: docs/Global_Rules.md** 

## **architecture_doc: docs/ARCHI.md** 

## **design_system: docs/DESIGN_SYSTEM.md (optional)**

# **1. Product Overview**

* **One-line Summary:**  
* **Value Proposition:** [High-level user valueâ€”what changes for the user?]  
* **Business Goals:**

## **1.1 Scope & Boundaries**

| Scope | Description |
| :---- | :---- |
| **In Scope** | [Main capabilities, flows, and components included] |
| **Out of Scope** | [Adjacent features or systems explicitly excluded] |

## **1.2 Target Audience**

* **Primary Persona:**  
* **User Constraints:** [e.g., "Must work on low-bandwidth mobile networks."]

## **1.3 Expected Outcomes (Success Metrics)**

* **User Outcomes:** [e.g., "Users can complete checkout in < 3 clicks."]  
* **System Outcomes:** [e.g., "99.9% uptime for the payment gateway."]

# **2. User Interfaces (UI/UX)**

*This section defines the interaction layer. The AI should prioritize these patterns over generic layouts.*

## **2.1 Core Interaction Loop**

* **Entry Point:**  
* **Action:** [e.g., "User inputs name and selects template."]  
* **Feedback:**  
* **Completion:** [e.g., "User is redirected to the Editor view."]

## **2.2 Critical User Journeys (Mermaid)**

Code snippet

journey  
    title [Journey Name, e.g., Onboarding Flow]  
    section Discovery  
      Landing Page: 5: User  
      Sign Up Click: 5: User  
    section Configuration  
      Email Verification: 3: System  
      Profile Setup: 4: User  
    section First Value  
      Create First Item: 5: User

## **2.3 Interface Wireframes (ASCII)**

*Use these layouts as the spatial source of truth.*

View:  
+-------------------------------------------------------+  
| [Icon] Project Title |  
| Last edited: 2 hours ago |  
| |  
| +-------------------------------------------------+ |  
| | Progress Bar [============--------] 60% | |  
| +-------------------------------------------------+ |  
| |  
| [Avatar Pile] [Action Menu] |  
+-------------------------------------------------------+

## **2.4 UI Behaviors & States**

* **Loading:** [e.g., "Use skeleton loaders for table rows, not a full-page spinner."]  
* **Empty States:** [e.g., "If no data, show illustration and 'Create New' button."]  
* **Errors:** [e.g., "Form errors must appear inline below the specific field."]

# **3. Functional Requirements**

*Detailed logic for the "What". Implementation details belong in ARCHI.md.*

## **3.1 Feature: [Feature Name]**

**User Story:**

AS A [Persona]  
I WANT TO [Action]  
SO THAT

**Acceptance Criteria (Gherkin):**

* [ ] **Scenario 1: [Name]**  
  * **GIVEN** [Context]  
  * **WHEN** [Action]  
  * **THEN**

**Business Rules:**

* [ ] Rule 1: [e.g., "Users cannot delete a project with active members."]  
* [ ] Rule 2: [e.g., "Free tier is limited to 5 items."]

# **4. Open Questions**

* [ ][Question about edge cases or scope?]