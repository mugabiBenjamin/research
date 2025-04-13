# Python venv

## What is a venv in Python?

- A venv (`Virtual Environment`) is an isolated Python environment that allows you to manage dependencies separately for different projects. It keeps project-specific packages and Python versions separate from the system-wide Python installation.

## Where Should It Be Created?

- Inside the project directory

```plaintext
my_project/
├── venv/           # Virtual environment here
├── app.py
└── requirements.txt
```

### Example Workflow in Ubuntu

```python
# Create project directory
mkdir my_project && cd my_project

# Create and activate venv
python3 -m venv venv        
# The second `venv` is the name of the directory where the virtual environment files will be stored. This can be renamed (e.g., .venv, env, myenv).
source venv/bin/activate

# Install packages
pip install requests flask

# Generate requirements.txt
pip freeze > requirements.txt

# Deactivate when done
deactivate

# Remove venv folder
rm -rf venv
```

## How to Check for an Active venv in Ubuntu

```bash
# Print active venv path
echo $VIRTUAL_ENV
# If it returns a path (e.g., /home/user/project/venv), the venv is active.
# If it’s empty, no venv is active.
```

```bash
$ which pip
/home/user/project/venv/bin/pip     # venv is active
/usr/bin/pip                        # System-wide pip
```
