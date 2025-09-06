# SQLAlchemy & Alembic

Manage your database efficiently through `SQLAlchemy` and `Alembic`.

- [Create a Python virtual environment and install all the required packages](#create-a-python-virtual-environment-and-install-all-the-required-packages)
- [Initialize Alembic](#initialize-alembic)
- [Create a migration](#create-migration)

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

# Edit the `alembic.ini` file and proivide your database URL and mode.
sqlalchemy.url = postgresql+asyncpg://username:password@localhost:5432/employee_management_db

# Inside the env.py file
from app.database import Base      # where you define your SQLAlchemy Base
target_metadata = Base.metadata
```

## Create migration

```bash
alembic revision --autogenerate -m "First revision"
alembic upgrade head        # Apply all pending migrations
```

```bash
# Change a column in the models table
alembic revision --autogenerate -m "Drop name index"
alembic upgrade `code_version of the recently cretaed revision`
```

```bash
alembic downgrade -1
```

[Back to Top](#sqlalchemy--alembic)
