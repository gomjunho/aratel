# 🤖 ARATEL AI Agent Rules & Project Memory

This file serves as persistent memory and instructions for AI Agents (Antigravity/Gemini) working on the ARATEL codebase.

---

## 🚨 MANDATORY AGENT EXECUTION RULES

### 1. TDD (Test-Driven Development) Mode ONLY
* **ALWAYS** write test cases BEFORE implementing functional code (Red ➔ Green ➔ Refactor).
* Never write business logic or UI components without corresponding automated tests.
* Run tests locally (`bin/rails test` in `backend`/`web`, `flutter test --coverage` in `mobile`) to verify pass status before submitting work.

### 2. 100% Code Coverage Threshold
* **ALWAYS** maintain 100% code coverage across `backend`, `web`, and `mobile`.
* If coverage drops below 100%, write additional tests immediately.
* Do not bypass, lower, or comment out coverage checks (`SimpleCov.minimum_coverage 100`).

### 3. Gitmoji Commit Convention MUST BE USED FOR ALL COMMITS
* **EVERY** `git commit` message MUST begin with a valid Gitmoji.
* Standard mappings to use:
  * `:sparkles: feat: ...` (New features)
  * `:white_check_mark: test: ...` (Tests)
  * `:bug: fix: ...` (Bug fixes)
  * `:recycle: refactor: ...` (Refactoring)
  * `:memo: docs: ...` (Documentation)
  * `:green_heart: ci: ...` (CI/CD workflows)
  * `:building_construction: scaffold: ...` (Scaffolding/Architecture)
  * `:wrench: config: ...` (Configuration changes)
  * `:lock: security: ...` (Security implementations)
  * `:palette: style: ...` (UI/UX Styling)

---

## 🏛️ Project Architecture Memory

* **Backend**: Ruby on Rails 8.0 API Server (`/backend`)
* **Web**: Ruby on Rails 8.0 Web App (`/web`)
* **Mobile**: Flutter iOS/Android App (`/mobile`)
* **Spec Documents**: [arch.docx](file:///Users/zion/Projects/aratel/arch.docx), [flow.docx](file:///Users/zion/Projects/aratel/flow.docx), [ISSUES.md](file:///Users/zion/Projects/aratel/ISSUES.md)
