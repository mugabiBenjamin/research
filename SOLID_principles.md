# SOLID Principles

- [SOLID Principles](#solid-principles)
  - [Single Responsibility Principle (SRP)](#single-responsibility-principle-srp)
  - [Open/Closed Principle (OCP)](#openclosed-principle-ocp)
  - [Liskov Substitution Principle (LSP)](#liskov-substitution-principle-lsp)
  - [Interface Segregation Principle (ISP)](#interface-segregation-principle-isp)
  - [Dependency Inversion Principle (DIP)](#dependency-inversion-principle-dip)

## Single Responsibility Principle (SRP)

**Rule:** Each class should have one, and only one, reason to change.

A "reason to change" maps to a responsibility. If a class handles payroll logic *and* database persistence *and* report formatting, then any change in any of those three domains forces you to touch the same class - making unrelated changes risky and difficult to test in isolation.

> **How to spot a violation:** Ask yourself - "If I changed how reports are formatted, would I have to open this same class?" If yes, that class has too many responsibilities.

- **Bad example - one class doing everything:**

```java
class Employee {
    private String name;
    private double salary;

    public double calculatePay() { /* payroll logic */ }
    public void saveToDatabase() { /* persistence logic */ }
    public String generateReport() { /* formatting logic */ }
}
```

Changing the report format, switching databases, or updating payroll rules all require modifying the same `Employee` class - three separate teams could be stepping on each other's toes.

- **Good example - each class owns one concern:**

```java
class Employee {
    private String name;
    private double salary;
    // Data only - no behaviour that belongs elsewhere
}

class PayCalculator {
    public double calculatePay(Employee employee) {
        // Only changes if payroll rules change
    }
}

class EmployeeRepository {
    public void save(Employee employee) {
        // Only changes if persistence strategy changes
    }
}

class EmployeeReportGenerator {
    public String generateReport(Employee employee) {
        // Only changes if report format changes
    }
}
```

Now each class has exactly one reason to change. You can swap the database, rewrite the report template, or change pay calculation rules without touching the others.

**Benefits:**

- **Readability** - smaller classes are easier to understand at a glance
- **Maintainability** - changes are localised to one place
- **Testability** - each class can be unit-tested independently
- **Reusability** - `PayCalculator` can be reused anywhere, not just inside `Employee`

## Open/Closed Principle (OCP)

**Rule:** Software entities should be open for extension but closed for modification.

Once a class is tested and working, you should be able to add new behaviour by *extending* it, not by *editing* it. Editing existing code risks breaking what already works.

> **How to spot a violation:** If adding a new employee type (e.g. `Intern`) means opening an existing class and adding another `else if` branch, OCP is being violated.

- **Bad example - adding a new type means editing existing code:**

```java
class PayCalculator {
    public double calculatePay(Employee employee) {
        if (employee instanceof Manager) {
            // manager pay logic
        } else if (employee instanceof Engineer) {
            // engineer pay logic
        } else if (employee instanceof Intern) {
            // now you're forced to open and edit this class again
        }
        // Every new type = another edit here. This is the type-checking antipattern.
    }
}
```

Every new employee type forces you back into `PayCalculator` - a class you've already tested and shipped.

- **Good example - new types extend without touching existing code:**

```java
interface Employee {
    double calculatePay();
}

class Manager implements Employee {
    @Override
    public double calculatePay() {
        // Manager-specific logic: base salary + management allowance
    }
}

class Engineer implements Employee {
    @Override
    public double calculatePay() {
        // Engineer-specific logic: base salary + technical bonus
    }
}

class Intern implements Employee {
    @Override
    public double calculatePay() {
        // Intern-specific logic: stipend only
        // Zero changes needed in PayCalculator to add this type
    }
}

class PayCalculator {
    public double calculatePay(Employee employee) {
        return employee.calculatePay(); // Works for any Employee, now and in the future
    }
}
```

Adding `Intern` required zero changes to `PayCalculator`. That is the payoff: the system grows by *addition*, not by *modification*.

**Benefits:**

- **Open for extension** - new behaviour can always be added via new classes
- **Closed for modification** - stable, tested code is not touched
- **Flexibility** - the system adapts without accumulating fragile conditional logic
- **Maintainability** - bugs are less likely to be introduced by changes

## Liskov Substitution Principle (LSP)

**Rule:** You should be able to replace a superclass object with any of its subclasses without changing the correctness of the program.

In other words, a subclass must honour the *contract* of its parent. If using a subclass breaks code that worked fine with the parent, the substitution principle is violated.

> **How to spot a violation:** If a subclass throws an exception for a method the parent supports, or silently ignores it, you have an LSP violation. The smell: `UnsupportedOperationException` in an override.

- **Bad example - subclass breaks the parent's contract:**

```java
class Employee {
    public void paySalary() { /* pays the salary */ }
    public void payBonus() { /* pays the bonus */ }
}

class ContractEmployee extends Employee {
    @Override
    public void payBonus() {
        throw new UnsupportedOperationException("Contract employees don't get bonuses");
    }
}

Employee employee = new ContractEmployee();
employee.paySalary(); // Works fine
employee.payBonus();  // Blows up at runtime - LSP violated
```

Any code that accepts an `Employee` and calls `payBonus()` will fail for `ContractEmployee`, even though it should be substitutable.

- **Good example 1 - Separate Interfaces (preferred approach):**

Model the distinction at the type level. Use this when the difference between types is meaningful and clear-cut.

```java
interface Payable {
    void paySalary();
}

interface BonusEligible extends Payable {
    void payBonus();
}

class Employee implements BonusEligible {
    public void paySalary() { /* ... */ }
    public void payBonus() { /* ... */ }
}

class ContractEmployee implements Payable {
    public void paySalary() { /* ... */ }
    // payBonus() doesn't even exist here - no contract to break
}
```

`ContractEmployee` never promises bonus behaviour, so it can never violate it.

- **Good example 2 - Optional Bonus Logic (use sparingly):**

Allow an empty implementation in the base class so no contract is broken. Use this only when the distinction is minor and not worth a full interface split.

```java
class Employee {
    public void paySalary() { /* ... */ }
    public void payBonus() { /* no-op by default */ }
}

class ContractEmployee extends Employee {
    @Override
    public void payBonus() {
        // Intentional no-op: contract employees receive no bonus
    }
}
```

Caution: silent no-ops can mislead callers. Only use this if the empty case is a clearly documented, expected outcome.

- **Good example 3 - Handling at a Higher Level (use as a last resort):**

Push the type check out to a dedicated processor rather than letting it explode in polymorphic code.

```java
class BonusProcessor {
    public void payBonus(Employee employee) {
        if (employee instanceof BonusEligible) {
            // Safe: only runs for eligible types
        }
        // Otherwise does nothing - no exception thrown
    }
}
```

This works but reintroduces a type check, which can be a code smell. Prefer Example 1 when possible.

**Benefits:**

- **Correctness** - polymorphism works reliably without runtime surprises
- **Maintainability** - callers don't need to know the concrete type
- **Flexibility** - subclasses can be swapped freely without defensive checks

## Interface Segregation Principle (ISP)

**Rule:** Many specific interfaces are better than one large, general-purpose interface.

No class should be forced to implement methods it doesn't need. A bloated interface creates false dependencies - implementing classes get coupled to behaviour that has nothing to do with them.

> **How to spot a violation:** If a class implements an interface but throws `UnsupportedOperationException` (or leaves methods empty) for some methods, the interface is too broad. This is distinct from LSP: LSP is about honouring a contract you've inherited; ISP is about not being forced to sign a contract you don't need in the first place.

- **Bad example - one interface forces irrelevant methods:**

```java
interface EmployeeActions {
    void work();
    void attendMeetings();
    void submitTimesheet();
}

class Manager implements EmployeeActions {
    public void work() { /* ... */ }
    public void attendMeetings() { /* ... */ }
    public void submitTimesheet() {
        throw new UnsupportedOperationException("Managers don't submit timesheets");
        // Manager is forced to implement something it can't meaningfully do
    }
}
```

Changing `submitTimesheet()` in the interface now breaks `Manager`, even though `Manager` has no business caring about timesheets.

- **Good example - focused interfaces, implement only what's relevant:**

```java
interface Worker {
    void work();
}

interface MeetingAttendee {
    void attendMeeting();
}

interface TimesheetSubmitter {
    void submitTimesheet();
}

class Manager implements Worker, MeetingAttendee {
    // Implements exactly what a Manager does - nothing more
    public void work() { /* ... */ }
    public void attendMeeting() { /* ... */ }
}

class ContractWorker implements Worker, TimesheetSubmitter {
    // ContractWorker works and submits timesheets, but doesn't attend meetings
    public void work() { /* ... */ }
    public void submitTimesheet() { /* ... */ }
}
```

Each class only depends on the interfaces it actually uses. Changes to `TimesheetSubmitter` now have zero impact on `Manager`.

**Benefits:**

- **Flexibility** - classes can mix and match only the interfaces they need
- **Reduced coupling** - changes in one interface don't ripple out to unrelated implementors
- **Cleaner interfaces** - each interface represents a single, coherent capability
- **Maintainability** - smaller interfaces are easier to evolve independently

## Dependency Inversion Principle (DIP)

**Rule:** High-level modules should depend on abstractions, not on low-level implementations.

When a class hard-codes a dependency on a concrete class (like `EmailSender`), it becomes tightly coupled to that specific implementation. Swapping it out - for testing, or for a new notification channel - requires editing the high-level class itself.

> **How to spot a violation:** If a high-level class directly constructs or references a concrete low-level class by name (e.g. `new EmailSender()`), it's coupled to that implementation. The smell: you can't unit test the class without also running the real email sender.

- **Bad example - high-level class depends directly on a concrete implementation:**

```java
class Employee {
    public void notifyPromotion() {
        EmailSender emailSender = new EmailSender(); // Hardcoded dependency
        emailSender.sendPromotionEmail(this);
        // If you want to switch to SMS, or mock this in a test, you must edit Employee
    }
}
```

`Employee` now knows exactly *how* notifications are sent. It's coupled to email forever - or until someone opens this class and changes it.

- **Good example - depend on an abstraction, inject the implementation:**

```java
interface Notifier {
    void sendNotification(Employee employee);
}

class EmailSender implements Notifier {
    @Override
    public void sendNotification(Employee employee) {
        // Send an email
    }
}

class SMSSender implements Notifier {
    @Override
    public void sendNotification(Employee employee) {
        // Send an SMS
    }
}

class SlackNotifier implements Notifier {
    @Override
    public void sendNotification(Employee employee) {
        // Post to Slack
    }
}

class Employee {
    public void notifyPromotion(Notifier notifier) {
        notifier.sendNotification(this);
        // Employee has no idea whether it's email, SMS, or Slack - and doesn't need to
    }
}
```

`Employee` depends on the `Notifier` abstraction. You can pass in any implementation - including a mock in tests - without touching `Employee` at all. This is also the principle that makes dependency injection frameworks (like Spring) possible: they wire up the concrete implementations so your high-level code never has to.

**Benefits:**

- **Loose coupling** - high-level logic doesn't care about low-level details
- **Reusability** - `Employee` works with any `Notifier`, present or future
- **Improved testing** - inject a mock `Notifier` to test `Employee` in complete isolation

[Back to Top](#solid-principles)
