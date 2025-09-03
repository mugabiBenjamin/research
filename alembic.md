# SQLAlchemy & Alembic

Manage your database efficiently through `SQLAlchemy` and `Alembic`.

- [Create a Python virtual environment and install all the required packages](#create-a-python-virtual-environment-and-install-all-the-required-packages)
- [Initialize Alembic](#initialize-alembic)
- [Create a migration](#create-migration)
- [Push the migration to database](#push-the-migration-to-database)

## Create a Python virtual environment and install all the required packages

```bash
python3 -m venv venv
source venv/bin/activate
pip install alembic

# or

uv venv
source venv/bin/activate
uv add alembic
```

## Initialize Alembic

```bash
alembic init alembic

# Alembic will create a directory structure like this
.
├── alembic
│   ├── env.py
│   ├── README
│   ├── script.py.mako
│   └── versions
├── alembic.ini
├── main.py
├── pyproject.toml
├── README.md
└── uv.lock

# Edit the `alembic.ini` file and proivide your database URL and mode.
sqlalchemy.url = postgresql+asyncpg://username:password@localhost:5432/employee_management_db
```

## Create migration

```bash
alembic revision -m "create users table"
alembi upgrade head
alembic downgrade -1
alembic current
alembic upgrade head
alembic history
alembic merge -m "commit message"


alembic revision --autogenerate -m "YOUR COMMENT"
```

## Push the migration to database

```bash
alembic upgrade head
```

[Back to Top](#sqlalchemy--alembic)
