# SOLID Standards & Quality Gates

This document defines the strictness levels for SOLID principles in this project, tailored for different development stages.

---

### 1. Single Responsibility Principle (SRP) — 100% Mandatory
Every class or function must have only one reason to change.
- **Rationale:** Mixing concerns (e.g., API calls + formatting + logging) makes maintenance impossible.
- **Implementation:** `PaymentService` manages payments; logging goes to `Logger`; persistence goes to `Repository`.

### 2. Open/Closed Principle (OCP) — 80-90% Recommended
Code should be open for extension but closed for modification.
- **Rationale:** Adding new payment types (e.g., Click, Payme) should not break engine logic.
- **Implementation:** Use a `PaymentProvider` interface instead of rigid `switch-case` blocks. Add new providers by creating new classes.

### 3. Liskov Substitution Principle (LSP) — 100% Mandatory
Subclasses must be replaceable for their base classes without breaking the app.
- **Rationale:** If `CashPayment.pay()` throws an unexpected exception while others don't, the app crashes.
- **Implementation:** Any function accepting `BasePayment` must work identically whether passed `Stripe` or `PayPal`.

### 4. Interface Segregation Principle (ISP) — 70-80% Sufficient
Split bloated interfaces into smaller, more specific ones.
- **Rationale:** Classes shouldn't be forced to implement methods they don't need.
- **Implementation:** Instead of one `PaymentInterface`, use `Refundable`, `Withdrawable`, `Authorizable`.

### 5. Dependency Inversion Principle (DIP) — 90% Mandatory
High-level modules should depend on abstractions, not low-level implementations.
- **Rationale:** Changing the networking client (Dio to Http) or Database shouldn't require rewrites.
- **Implementation:** Accept `BaseClient` in the constructor instead of hardcoding `final api = Dio()`.

---

### When to "Relax" SOLID
1. **MVP (Minimum Viable Product):** Speed is priority. OCP/ISP can be slightly relaxed.
2. **Small Scripts:** Short-lived tools with < 2 week lifespan.
3. **Avoid Over-engineering:** Do not create 5 interfaces for 2 lines of code. Keep it pragmatic.
