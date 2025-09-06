# SQLAlchemy & Alembic Reference Guide

A comprehensive guide for database migrations using SQLAlchemy and Alembic.

## Table of Contents

1. [Setup & Installation](#setup--installation)
2. [Project Initialization](#project-initialization)
3. [Core Commands](#core-commands)
   - [Migration Creation](#migration-creation)
   - [Applying Migrations](#applying-migrations)
   - [Rolling Back Migrations](#rolling-back-migrations)
   - [Status & Information](#status--information)
4. [Advanced Commands](#advanced-commands)
5. [Integration with Existing Projects](#integration-with-existing-projects)
6. [Workflow Comparison](#workflow-comparison)
7. [Best Practices](#best-practices)

---

## Setup & Installation

### Create Virtual Environment and Install Dependencies

```bash
# Using venv
python3 -m venv venv
source venv/bin/activate
pip install alembic psycopg2-binary

# Using uv (faster alternative)
uv venv
source venv/bin/activate
uv add alembic psycopg2-binary
```

---

## Project Initialization

### 1. Initialize Alembic

```bash
alembic init alembic
```

### 2. Configure Database Connection

Edit `alembic.ini`:

```ini
sqlalchemy.url = postgresql+asyncpg://username:password@localhost:5432/employee_management_db
```

### 3. Configure Models Import

Edit `alembic/env.py`:

```python
from app.core.database import Base
from app import models  # Import all models so Alembic can detect them

target_metadata = Base.metadata
```

---

## Core Commands

### Migration Creation

#### Auto-generate Migration

```bash
# Detect schema changes automatically
alembic revision --autogenerate -m "Description of changes"
```

#### Manual Migration

```bash
# Create empty migration template
alembic revision -m "Manual migration description"
```

### Applying Migrations

```bash
# Apply all pending migrations
alembic upgrade head

# Apply one migration forward
alembic upgrade +1

# Apply to specific revision
alembic upgrade [revision_id]
```

### Rolling Back Migrations

```bash
# Go back one migration
alembic downgrade -1

# Go back to base (empty database)
alembic downgrade base

# Go to specific revision
alembic downgrade [revision_id]
```

### Status & Information

```bash
# Show current revision
alembic current

# Show migration history
alembic history --verbose

# Show latest revision(s)
alembic heads

# Check for pending migrations
alembic check
```

---

## Advanced Commands

### Branch Management

```bash
# Show migration branches
alembic branches

# Merge multiple heads
alembic merge -m "merge message" [head1] [head2]
```

### Inspection & Editing

```bash
# Show specific revision content
alembic show [revision_id]

# Edit revision file
alembic edit [revision_id]
```

### Database State Management

```bash
# Mark database as being at specific revision (without running migrations)
alembic stamp head
alembic stamp [revision_id]
alembic stamp base
```

---

## Integration with Existing Projects

### For Your Current Employee Attendance System

Since you already have a database created from DDL scripts, follow these steps:

#### Step 1: Install and Initialize

```bash
pip install alembic psycopg2-binary
alembic init alembic
```

#### Step 2: Configure Alembic

**`alembic.ini`:**

```ini
sqlalchemy.url = postgresql+psycopg2://user:password@localhost:5432/employee_management_db
```

**`alembic/env.py`:**

```python
from app.core.database import Base
# Import all your model modules
from app.models import (
    users, departments, roles, user_roles, user_departments,
    attendance_records, attendance_summary, leave_requests,
    leave_balances, leave_policies, shift_patterns, shift_assignments,
    overtime_records, holiday_calendar, time_corrections,
    employee_emergency_contacts, employee_hierarchy,
    leave_approval_workflow, system_logs
)

target_metadata = Base.metadata
```

#### Step 3: Create Baseline Migration

```bash
# Generate migration that reflects your current database state
alembic revision --autogenerate -m "baseline migration"

# Review the generated migration file in alembic/versions/
# It should contain all your existing tables

# Mark database as already at this migration level (don't apply it)
alembic stamp head
```

#### Step 4: Future Workflow

From now on, when you need database changes:

1. **Modify your SQLAlchemy models** (not DDL scripts)
2. **Generate migration:**

   ```bash
   alembic revision --autogenerate -m "add new column to users table"
   ```

3. **Review the generated migration file**
4. **Apply the migration:**

   ```bash
   alembic upgrade head
   ```

---

## Workflow Comparison

### Your Current Workflow

```plaintext
DDL Script → Models → Schemas → Services → Routes
```

### Alembic-First Workflow

```plaintext
Models → Migration (auto-generated) → Apply Migration → Schemas → Services → Routes
```

### What Changes with Alembic

#### Before (Manual DDL)

1. Write SQL DDL script
2. Run script against database
3. Create/update SQLAlchemy models to match
4. Create Pydantic schemas
5. Develop services and routes

#### After (Alembic)

1. **Create/modify SQLAlchemy models**
2. **Generate migration:** `alembic revision --autogenerate -m "description"`
3. **Review and edit migration if needed**
4. **Apply migration:** `alembic upgrade head`
5. Create Pydantic schemas
6. Develop services and routes

### Key Benefits

- **Version control** for database schema
- **Rollback capability** for schema changes
- **Team synchronization** of database changes
- **Automatic change detection**
- **Production deployment safety**

---

## Best Practices

### Migration Management

1. **Always review auto-generated migrations** before applying
2. **Use descriptive migration messages**
3. **Test migrations in development first**
4. **Keep migrations small and focused**
5. **Never edit applied migrations** - create new ones instead

### Team Workflows

1. **Pull latest migrations** before creating new ones:

   ```bash
   git pull
   alembic upgrade head
   ```

2. **Generate migration after model changes:**

   ```bash
   alembic revision --autogenerate -m "descriptive message"
   ```

3. **Commit both model changes and migration files**

### Production Deployments

1. **Backup database** before applying migrations
2. **Test migrations on staging environment**
3. **Use `alembic check`** in CI/CD to detect pending migrations
4. **Apply migrations during deployment:**

   ```bash
   alembic upgrade head
   ```

### Common Commands Summary

| Command                                    | Purpose                             |
| ------------------------------------------ | ----------------------------------- |
| `alembic revision --autogenerate -m "msg"` | Create new migration                |
| `alembic upgrade head`                     | Apply all pending migrations        |
| `alembic downgrade -1`                     | Rollback one migration              |
| `alembic current`                          | Show current database revision      |
| `alembic history`                          | Show migration history              |
| `alembic stamp head`                       | Mark DB as current without applying |
| `alembic check`                            | Check for pending migrations        |

---

## Troubleshooting

### Multiple Heads Error

When multiple developers create migrations simultaneously:

```bash
alembic merge -m "merge conflicting migrations" head1 head2
alembic upgrade head
```

### Reset to Clean State

```bash
alembic downgrade base
alembic upgrade head
```

### Skip Specific Migration

```bash
alembic stamp [revision_to_skip]
alembic upgrade head
```

[Back to Top](#sqlalchemy--alembic-reference-guide)
