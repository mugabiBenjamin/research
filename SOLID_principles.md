# SOLID Principles

- [SOLID Principles](#solid-principles)
  - [Single Responsibility Principle (SRP)](#single-responsibility-principle-srp)
  - [Open/Closed Principle (OCP)](#openclosed-principle-ocp)
  - [Liskov Substitution Principle (LSP)](#liskov-substitution-principle-lsp)
    - [Separate Interfaces](#separate-interfaces)
    - [Optional Bonus Logic](#optional-bonus-logic)
    - [Handling Bonus Logic at a Higher Level](#handling-bonus-logic-at-a-higher-level)
  - [Interface Segregation Principle (ISP)](#interface-segregation-principle-isp)
  - [Dependency Inversion Principle (DIP)](#dependency-inversion-principle-dip)

## Single Responsibility Principle (SRP)

Each class should have only one reason to change. Each class should have one responsibility.

- **Bad code example:**

```java
class Employee {
    private String name;
    private double salary;
    // ... other attributes
    
    public double calculatePay() { /* ... */ }
    public void saveToDatabase() { /* ... */ }
    public String generateReport() { /* ... */ }
}
```

- **Good code example:**

```java
class Employee {
    // ... attributes only
}

class PayCalculator {
    public double calculatePay(Employee employee) { }
}

class EmployeeRepository {
    public void save(Employee employee) { }
}

class EmployeeReportGenerator {
    public String generateReport(Employee employee) { }
}
```

- Readability
- Maintainability
- Testability
- Reusability

## Open/Closed Principle (OCP)

Software entities should be open to extension but closed to modification.

- **Bad code example:**

```java
class PayCalculator {
    public double calculatePay(Employee employee) {
        if (employee instanceof Manager) {
            // calculate manager's pay
        } else if (employee instanceof Engineer) {
            // calculate engineer's pay
        } // ... and so on
    }
}
```

- **Good code example:**

```java
interface Employee {
    double calculatePay();
}

class Manager implements Employee {
    // ... attributes
    @Override
    public double calculatePay() {
        // Specific logic for calculating manager's pay.
    }
}

class Engineer implements Employee {
    // ... attributes
    @Override
    public double calculatePay() {
        // Specific logic for calculating engineer's pay
    }
}

// ... (similar classes for Salesperson, Intern, etc.)

class PayCalculator {
    public double calculatePay(Employee employee) {
        return employee.calculatePay();
    }
}
```

- Open for extension
- Closed for modification
- Flexibility
- Maintainability

## Liskov Substitution Principle (LSP)

Replace superclass object with its subclass object without affecting the correctness of the program.

- **Bad code example:**

```java
class Employee {
    public void paySalary() { /* ... */ }
    public void payBonus() { /* ... */ }
}

class ContractEmployee extends Employee {
    // ... but cannot receive a bonus
    @Override
    public void payBonus() {
        throw new UnsupportedOperationException("Contract employees don't get bonuses");
    }
}

Employee employee = new ContractEmployee(); // Polymorphism
employee.paySalary(); // Works fine
employee.payBonus(); // Throws an exception!
```

- **Good code examples:**

### Separate Interfaces

```java
interface Payable {
    void paySalary();
}

interface BonusEligible extends Payable {
    void payBonus();
}

class Employee implements BonusEligible { }
class ContractEmployee implements Payable { }
```

### Optional Bonus Logic

```java
class Employee {
    public void paySalary() { }
    public void payBonus() { } // Could have an empty implementation
}

class ContractEmployee extends Employee {
    @Override
    public void payBonus() {
        // Do nothing or log a message
    }
}
```

### Handling Bonus Logic at a Higher Level

```java
class BonusProcessor {
    public void payBonus(Employee employee) {
        if (employee instanceof BonusEligible) {
            // Calculate and pay bonus
        }
    }
}
```

- Correctness
- Maintainability
- Flexibility

## Interface Segregation Principle (ISP)

Many client-specific interfaces are better than one general-purpose interface.

- **Bad code example:**

```java
interface EmployeeActions {
    void work();
    void attendMeetings();
    void submitTimesheet();
}

class Manager implements EmployeeActions {
    // ... implements work() and attendMeeting()
    public void submitTimesheet() {
        throw new UnsupportedOperationException("Managers don't submit timesheets");
    }
}
```

- **Good code example:**

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
    // ... implements work() and attendMeeting()
}

class ContractWorker implements Worker {
    // ... implements work()
}
```

- Flexibility
- Reduced Coupling
- Cleaner Interfaces
- Maintainability

## Dependency Inversion Principle (DIP)

High-level modules should depend on abstractions (interfaces) and not low level modules.

- **Bad code example:**

```java
class Employee {
    public void notifyPromotion(EmailSender emailSender) {
        emailSender.sendPromotionEmail(this);
    }
}
```

- **Good code example:**

```java
interface Notifier {
    void sendNotification(Employee employee);
}

class EmailSender implements Notifier { }
class SMSSender implements Notifier { }

class Employee {
    public void notifyPromotion(Notifier notifier) {
        notifier.sendNotification(this);
    }
}
```

- Loose Coupling
- Reusability
- Improved Testing

[Back to Top](#solid-principles)
