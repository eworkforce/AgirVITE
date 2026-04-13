# **⚙️ Global Development Rules**

Version: 2.0  
Last Updated: December 2024  
Purpose: These rules govern all coding, architecture, and design decisions to ensure consistency, security, and maintainability across the system.

## **📌 RULE HIERARCHY & CONFLICT RESOLUTION**

**IF TWO RULES CONFLICT:**

1. **Security (Rule 15\)** \> Everything  
2. **Architecture alignment (Rule 14\)** \> Implementation preferences  
3. **Clarity** \> Brevity  
4. **When in doubt, ASK** rather than assume

**THESE RULES EVOLVE.** Suggest improvements when you see gaps or conflicts.

## **1\. CONTEXT FIRST — NO GUESSWORK**

* **DO NOT WRITE A SINGLE LINE OF CODE UNTIL YOU UNDERSTAND THE SYSTEM.**  
* **IMMEDIATELY LIST FILES IN THE TARGET DIRECTORY.**  
* ASK ONLY THE NECESSARY CLARIFYING QUESTIONS. NO FLUFF.  
* DETECT AND FOLLOW EXISTING PATTERNS. MATCH STYLE, STRUCTURE, AND LOGIC.  
* IDENTIFY ENVIRONMENT VARIABLES, CONFIG FILES, AND SYSTEM DEPENDENCIES.

## **2\. CHALLENGE THE REQUEST — DON’T BLINDLY FOLLOW**

* IDENTIFY EDGE CASES IMMEDIATELY.  
* ASK SPECIFICALLY: WHAT ARE THE INPUTS? OUTPUTS? CONSTRAINTS?  
* QUESTION EVERYTHING THAT IS VAGUE OR ASSUMED.  
* REFINE THE TASK UNTIL THE GOAL IS BULLET-PROOF.  
* **IF THE REQUEST VIOLATES BEST PRACTICES, PROPOSE ALTERNATIVES.**

## **3\. HOLD THE STANDARD — EVERY LINE MUST COUNT**

* CODE MUST BE MODULAR, TESTABLE, CLEAN.  
* **DOCUMENT PUBLIC INTERFACES:** Use language-appropriate conventions (JSDoc, Python docstrings, Go comments, JavaDoc).  
* **EXPLAIN "WHY," NOT "WHAT":** Code should be self-documenting; comments explain reasoning, edge cases, and non-obvious decisions.  
* SUGGEST BEST PRACTICES IF CURRENT APPROACH IS OUTDATED.  
* **IF YOU KNOW A BETTER WAY — SPEAK UP, BUT JUSTIFY THE CHANGE.**

## **4\. ZOOM OUT — THINK BIGGER THAN JUST THE FILE**

* DON’T PATCH. DESIGN.  
* THINK ABOUT MAINTAINABILITY, USABILITY, SCALABILITY.  
* CONSIDER ALL COMPONENTS (FRONTEND, BACKEND, DATABASE, USER INTERFACE).  
* PLAN FOR THE USER EXPERIENCE, NOT JUST THE FUNCTIONALITY.  
* **CONSIDER THE DEVELOPER EXPERIENCE:** Will another developer understand this in 6 months?

## **5\. WEB TERMINOLOGY — SPEAK THE RIGHT LANGUAGE**

* FRAME SOLUTIONS IN TERMS OF APIs, ROUTES, COMPONENT STRUCTURE, DATA FLOW.  
* UNDERSTAND FRONTEND-BACKEND INTERACTIONS BEFORE CHANGING EITHER.  
* **USE INDUSTRY-STANDARD TERMINOLOGY:** RESTful, GraphQL, WebSockets, Server-Side Rendering, Client-Side Rendering, etc.

## **6\. ONE FILE, ONE RESPONSE**

* **PROVIDE COMPLETE FILE CONTENTS IN EACH RESPONSE.**  
* **IF A CHANGE SPANS MULTIPLE FILES:** Present them all in a single response with clear separators and explanations.  
* DO NOT RENAME METHODS UNLESS ABSOLUTELY NECESSARY OR EXPLICITLY REQUESTED.  
* **ATOMIC CHANGES \= ONE LOGICAL FEATURE/FIX, NOT ONE FILE.**  
* SEEK APPROVAL ONLY WHEN THE TASK NEEDS CLARITY — OTHERWISE, EXECUTE.

## **7\. ENFORCE STRICT STANDARDS**

* **FILE SIZE LIMITS (Guidelines exclude comments/imports):**  
  * **Logic files:** 500 lines (refactor into modules if exceeded)  
  * **Component files:** 300 lines (split into subcomponents)  
  * **Config/Data files:** No hard limit, but flag excessive complexity  
* **COMPLEXITY OVER LENGTH:** A 200-line function is worse than a 600-line well-structured file.  
* **HIGHLIGHT ANY FILE GROWING BEYOND REASONABLE CONTROL.**  
* USE LINTERS, FORMATTERS. **IF THEY’RE MISSING — FLAG IT AND RECOMMEND SETUP.**  
* **NAMING CONVENTIONS:** Follow project standards or suggest industry best practices.

## **8\. MOVE FAST, BUT WITH CONTEXT**

* **ALWAYS BULLET YOUR PLAN BEFORE EXECUTION:**  
  * **WHAT** you’re doing  
  * **WHY** you’re doing it  
  * **WHAT** you expect to change  
  * **POTENTIAL RISKS** or side effects  
* **AFTER EXECUTION:** Summarize what was changed and what to verify.

## **9\. ABSOLUTE DO-NOTS**

* **DO NOT CHANGE TRANSLATION KEYS** unless specified.  
* **DO NOT ADD LOGIC** that doesn’t serve the stated requirement.  
* **ERROR HANDLING:** Use try-catch only for recoverable errors at boundaries (API calls, I/O, file operations). Let exceptions propagate for programming errors (null checks, type validation).  
* **DO NOT CREATE "GOD OBJECTS"** or utility dumping grounds (files with \>20 unrelated functions).  
* **DO NOT CREATE SIDE EFFECTS** without explicitly documenting them in your response.  
* **DO NOT COMMIT COMMENTED-OUT CODE** unless temporarily needed for debugging (and mark it clearly).  
* **DO NOT IGNORE COMPILER/LINTER WARNINGS.** Fix them or explain why they can be safely ignored.

## **10\. SYSTEM STABILITY IS YOUR RESPONSIBILITY**

* YOUR WORK ISN’T DONE UNTIL THE SYSTEM IS STABLE.  
* THINK THROUGH ALL CONSEQUENCES OF YOUR CHANGES.  
* **IF YOU BREAK SOMETHING IN ONE PLACE, FIX IT ACROSS THE ENTIRE PROJECT.**  
* **CONSIDER DEPLOYMENT IMPACT:** Will this break in production? Does it need feature flags?

## **11\. THINK LIKE A HUMAN**

* CONSIDER NATURAL BEHAVIOR.  
* **HOW WOULD A USER INTERACT WITH THIS?**  
* **WHAT HAPPENS WHEN SOMETHING FAILS?** (Network errors, invalid input, timeout)  
* HOW CAN YOU MAKE THIS FEEL SEAMLESS?  
* **ACCESSIBILITY MATTERS:** Consider keyboard navigation, screen readers, color contrast.

## **12\. BEHAVIOR MOTTO**

* EXECUTE LIKE A **PROFESSIONAL CODER.**  
* THINK LIKE AN **ARCHITECT.**  
* DELIVER LIKE A **LEADER.**  
* **COMMUNICATE LIKE A TEACHER.**

## **13\. DOCUMENT SEARCH & VERIFICATION**

* **ALWAYS ENSURE YOU USE THE LATEST VERSION** of technical documentation (API, Framework, Libraries) before code generation.  
* **SEARCH SEQUENCE:**  
  1. First, search locally inside **FOLDER KNOWLEDGE.**  
  2. If not available in KNOWLEDGE, use **CONTEXT7 MCP SERVER.**  
  3. If not available (or unreachable) in CONTEXT7 MCP SERVER, search the **WEB.**  
* **VERIFICATION:** In the last case (Web search), share the first documents found with the user *before* using them.  
* **IF NO DOCUMENTATION FOUND:**  
  * Explicitly state "No official docs found, proceeding with best practices for \[technology\]"  
  * Justify your approach based on common patterns  
  * **FLAG THIS AS A RISK** to the user

## **14\. ARCHITECTURE AND DESIGN ADHERENCE**

* AGENT MUST **ALWAYS ENSURE ALIGNMENT** with the architecture document **DESIGN/ARCHI.md** while generating code.  
* **NO CODE SHOULD BE OUT OF CONTEXT** of the **DESIGN** folder documents.  
* Treat the design folder as the "Source of Truth" for structural decisions.  
* **IF THE DESIGN DOCUMENT CONFLICTS WITH THE REQUEST:** Flag this immediately and propose solutions.  
* **IF THE DESIGN DOCUMENT IS OUTDATED:** Suggest updates rather than working around it.

## **15\. SECURITY & DATA SAFETY**

* **NEVER HARDCODE SECRETS** (API Keys, passwords, tokens, connection strings) in the code. Use environment variables or secure vaults.  
* **VALIDATE ALL INPUTS** at the API/Interface level. Trust nothing coming from the client.  
* **PREVENT COMMON VULNERABILITIES:**  
  * SQL Injection: Use parameterized queries/ORMs  
  * XSS: Sanitize outputs, use framework escaping  
  * CSRF: Implement tokens for state-changing operations  
  * Path Traversal: Validate and sanitize file paths  
* **PRINCIPLE OF LEAST PRIVILEGE:** Grant minimum necessary permissions to services, users, and processes.  
* **SENSITIVE DATA:** Never log passwords, tokens, or PII. Redact in logs if necessary.  
* **DEPENDENCY SECURITY:** Flag known vulnerabilities in dependencies.

## **16\. ATOMIC & REVERSIBLE CHANGES**

* **MAKE SMALL, ATOMIC CHANGES.** Do not rewrite the entire system in one go unless explicitly requested.  
* **ENSURE BACKWARD COMPATIBILITY.** If you change an API, ensure old clients don't break immediately (deprecation strategy).  
* **ALWAYS PROVIDE A ROLLBACK STRATEGY** if the change involves:  
  * Database migrations  
  * Critical infrastructure updates  
  * Breaking API changes  
* **FEATURE FLAGS:** Suggest them for risky changes that need gradual rollout.

## **17\. THE PRE-COMMIT AUDIT**

**BEFORE FINAL OUTPUT, VERIFY THIS CHECKLIST:**

* \[ \] No unused imports, variables, or dead code  
* \[ \] Function/variable names follow project conventions  
* \[ \] Alignment with **DESIGN/ARCHI.md** verified  
* \[ \] No hardcoded secrets or sensitive data  
* \[ \] Error handling is appropriate (not over/under-done)  
* \[ \] Changes are atomic and focused on stated goal  
* \[ \] Breaking changes are clearly documented  
* \[ \] Code is linted and formatted per project standards  
* \[ \] No typos in function names or critical strings

**IF ANY ITEM FAILS, FIX BEFORE OUTPUT.**

## **18\. TESTING IS NOT OPTIONAL**

* **FOR NEW FEATURES:** Provide at minimum:  
  * Unit tests for core logic  
  * Integration test outline (or actual test if framework is clear)  
* **FOR BUG FIXES:** Include a regression test that would have caught the bug.  
* **FOR REFACTORS:** Ensure existing tests still pass. If no tests exist, flag this as a major risk.  
* **TEST PHILOSOPHY:**  
  * Tests should validate **behavior**, not implementation details  
  * Tests should be **readable** (they serve as documentation)  
  * Avoid brittle tests (don't test internal state unless necessary)  
* **TEST COVERAGE:** Aim for \>80% on critical business logic. Flag untested critical paths.

## **19\. DEPENDENCY MANAGEMENT**

* **BEFORE ADDING A NEW DEPENDENCY:**  
  * Check if existing dependencies can solve the problem  
  * Verify the package is actively maintained (recent commits, issue response, community size)  
  * Check bundle size impact for frontend dependencies (use bundlephobia.com for npm packages)  
  * Verify license compatibility with project (Avoid viral licenses like GPL for proprietary projects unless authorized)  
* **ALWAYS LOCK VERSIONS** in package.json, requirements.txt, go.mod, Gemfile.lock, etc.  
* **FLAG SECURITY VULNERABILITIES** if detected in existing dependencies (use npm audit, pip-audit, etc.).  
* **AVOID DEPENDENCY BLOAT:** Every dependency is a maintenance burden and potential security risk.

## **20\. PERFORMANCE AWARENESS**

* **ALWAYS CONSIDER:**  
  * **Database query efficiency:** Watch for N+1 queries, missing indexes, full table scans  
  * **Frontend rendering performance:** Avoid unnecessary re-renders, use virtualization for large lists  
  * **Memory implications:** Be cautious with large datasets, memory leaks in long-running processes  
  * **Network efficiency:** Minimize payload size, use pagination, implement caching  
* **IF A SOLUTION IS SIMPLE BUT SLOW, PROPOSE AN OPTIMIZED ALTERNATIVE.**  
* **MEASURE DON'T GUESS:** Suggest profiling tools when performance is critical (Chrome DevTools, py-spy, Go pprof, etc.).  
* **PREMATURE OPTIMIZATION IS EVIL, BUT OBVIOUS INEFFICIENCY IS LAZINESS.**

## **21\. ERROR MESSAGES & LOGGING**

* **ERROR MESSAGES SHOULD BE:**  
  * **Actionable:** Tell the user/developer what to do next  
  * **Specific:** "Invalid email format" not "Invalid input"  
  * **Never expose sensitive data:** Stack traces in production should be sanitized  
* **LOGGING BEST PRACTICES:**  
  * Use appropriate log levels (DEBUG, INFO, WARN, ERROR)  
  * Include context (user ID, request ID, timestamp)  
  * Make logs searchable and parseable  
  * Never log sensitive data (passwords, tokens, credit cards, PII)  
* **FAIL FAST, FAIL LOUDLY:** Errors should be caught early and reported clearly.

## **22\. CODE REVIEW MINDSET**

* **WRITE CODE AS IF THE NEXT PERSON TO MAINTAIN IT IS A VIOLENT PSYCHOPATH WHO KNOWS WHERE YOU LIVE.**  
* Ask yourself:  
  * Would I understand this code in 6 months?  
  * Can someone unfamiliar with this module understand the logic?  
  * Have I made the simple case simple and the complex case possible?  
* **SELF-REVIEW BEFORE SUBMISSION:** Read your own code as if you were reviewing someone else's.

## **23\. PROGRESSIVE ENHANCEMENT & GRACEFUL DEGRADATION**

* **DESIGN FOR FAILURE:**  
  * What happens if the API is down?  
  * What happens if JavaScript is disabled?  
  * What happens if the user has a slow connection?  
* **PROVIDE FALLBACKS:** Loading states, error boundaries, default values, retry mechanisms.  
* **DON'T ASSUME PERFECT CONDITIONS:** Networks fail, users have old browsers, data is malformed.

## **24\. DOCUMENTATION UPDATES**

* **IF YOU CHANGE BEHAVIOR, UPDATE THE DOCS.**  
* **PRIORITY ORDER:**  
  1. Inline code documentation (comments, docstrings)  
  2. README files (setup, usage, troubleshooting)  
  3. Architecture documents (DESIGN/ARCHI.md)  
  4. API documentation (Swagger/OpenAPI, GraphQL schemas)  
* **IF DOCUMENTATION IS MISSING OR OUTDATED, FLAG IT.**

## **25\. FINAL REMINDER: YOU ARE THE LAST LINE OF DEFENSE**

* **BEFORE YOU OUTPUT CODE:**  
  * Run through the Pre-Commit Audit (Rule 17\)  
  * Check alignment with Architecture (Rule 14\)  
  * Verify security requirements (Rule 15\)  
  * Consider testing implications (Rule 18\)  
* **IF SOMETHING FEELS WRONG, IT PROBABLY IS.** Trust your instincts and investigate.  
* **QUALITY \> SPEED.** A thoughtful delay is better than a costly mistake.

## **📚 APPENDIX: QUICK REFERENCE**

### **When to Use Each Search Method (Rule 13\)**

FOLDER KNOWLEDGE → Internal project docs, standards, conventions  
CONTEXT7 MCP → Team knowledge, historical decisions, past discussions  
WEB SEARCH → Official framework docs, library references, latest updates

### **File Size Red Flags (Rule 7\)**

⚠️  WARNING: 300+ lines in a React component  
⚠️  WARNING: 500+ lines in a business logic file  
🚨 CRITICAL: 1000+ lines in any logic file (refactor immediately)  
✅ OK: Large config files, data structures, generated code

### **Error Handling Decision Tree (Rule 9\)**

Is this an expected runtime error? (network, file I/O, user input)  
  YES → Use try-catch, log, return meaningful error  
  NO  → Is it a programming error? (null reference, type error)  
    YES → Let it fail fast, fix the bug  
    NO  → Should the application recover?  
      YES → Implement retry logic, fallbacks  
      NO  → Fail gracefully, alert monitoring

**END OF RULES**