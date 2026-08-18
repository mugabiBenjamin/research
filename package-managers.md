# Package Managers

- [Package Managers](#package-managers)
  - [npm vs yarn vs pnpm](#npm-vs-yarn-vs-pnpm)
    - [yarn installation](#yarn-installation)
    - [Key Differences](#key-differences)
    - [Key pnpm features worth noting](#key-pnpm-features-worth-noting)
    - [pnpm installation](#pnpm-installation)
  - [bun Command Cheat Sheet](#bun-command-cheat-sheet)
    - [bun installation](#bun-installation)
    - [Key bun features worth noting](#key-bun-features-worth-noting)
    - [Migrating from npm/yarn/pnpm to bun](#migrating-from-npmyarnpnpm-to-bun)
    - [Using bun as a runtime](#using-bun-as-a-runtime)
  - [pip Command Cheat Sheet](#pip-command-cheat-sheet)
    - [Usage Notes](#usage-notes)
  - [poetry Command Cheat Sheet](#poetry-command-cheat-sheet)
    - [Poetry Installation](#poetry-installation)
  - [composer Command Cheat Sheet](#composer-command-cheat-sheet)
  - [uv Command Cheat Sheet](#uv-command-cheat-sheet)
  - [Cloning a repo that uses uv](#cloning-a-repo-that-uses-uv)
  - [Migrating from `requirements.txt` to `uv`](#migrating-from-requirementstxt-to-uv)
  - [When to use each `sync`](#when-to-use-each-sync)
    - [`uv sync`](#uv-sync)
    - [`uv sync --extra dev`](#uv-sync---extra-dev)
    - [`uv add --editable .`](#uv-add---editable-)

## npm vs yarn vs pnpm

| npm Command               | Yarn Command                     | pnpm Command                     |
| ------------------------- | -------------------------------- | -------------------------------- |
| `npm install <package>`   | `yarn add <package>`             | `pnpm add <package>`             |
| `npm uninstall <package>` | `yarn remove <package>`          | `pnpm remove <package>`          |
| `npm install`             | `yarn install` (or just `yarn`)  | `pnpm install` (or just `pnpm`)  |
| `npm update`              | `yarn upgrade`                   | `pnpm update`                    |
| `npm list`                | `yarn list`                      | `pnpm list`                      |
| **`npm run dev`**         | **`yarn dev`**                   | **`pnpm dev`**                   |
| `npm start`               | `yarn start`                     | `pnpm start`                     |
| `npm run build`           | `yarn build`                     | `pnpm build`                     |
| `npm init`                | `yarn init`                      | `pnpm init`                      |
| `npm update <package>`    | `yarn upgrade <package>`         | `pnpm update <package>`          |
| `package-lock.json`       | `yarn.lock`                      | `pnpm-lock.yaml`                 |

### yarn installation

```bash
npm install -g yarn  # Install yarn globally
npm update -g yarn  # Update yarn globally
```

### Key Differences

- **Lock Files**: `npm` uses `package-lock.json` to lock down the versions of a package's dependencies, while `yarn` uses `yarn.lock`.
- **Speed**: Yarn generally performs installations faster than npm because it caches every package it downloads.
- **Workspaces**: Yarn supports workspaces to manage monorepos, which can simplify the management of multiple packages in a single repository.

### Key pnpm features worth noting

- pnpm uses a content-addressable storage system, making it faster and more disk-space efficient
- The lockfile format is YAML instead of JSON
- All commands follow npm's syntax more closely than Yarn does
- You can also use `pnpm i` as a shorthand for `pnpm install`

### pnpm installation

```bash
npm install -g pnpm  # Install pnpm globally
npm update -g pnpm  # Update pnpm globally
```

## bun Command Cheat Sheet

| npm/pnpm Command           | Bun Command                       |
| -------------------------- | --------------------------------- |
| `npm install <package>`    | `bun add <package>`               |
| `npm uninstall <package>`  | `bun remove <package>`            |
| `npm install`              | `bun install` (or just `bun i`)   |
| `npm update`               | `bun update`                      |
| `npm list`                 | `bun pm ls`                       |
| `npm run dev`              | `bun run dev` (or just `bun dev`) |
| `npm start`                | `bun start`                       |
| `npm run build`            | `bun run build`                   |
| `npm init`                 | `bun init`                        |
| `npm update <package>`     | `bun update <package>`            |
| `node file.js`             | `bun file.js`                     |
| `package-lock.json`        | `bun.lockb` (binary lockfile)     |
| `npx <package>`            | `bunx <package>`                  |
| `npm test`                 | `bun test` (built-in test runner) |

### bun installation

```bash
# macOS / Linux / WSL
curl -fsSL https://bun.sh/install | bash

# Upgrade bun to the latest version
bun upgrade
```

### Key bun features worth noting

- Bun is not just a package manager — it's an all-in-one runtime, bundler, transpiler, and test runner, written in Zig
- `bun install` uses aggressive binary caching, generally making it faster than npm, yarn, and pnpm for installs
- The lockfile (`bun.lockb`) is binary, not human-readable YAML/JSON like pnpm/yarn
- Runs `.ts`/`.tsx` files directly without a separate transpile step
- Ships a built-in test runner (`bun test`), bundler (`bun build`), and package manager, so it can fully replace Node + pnpm + a separate bundler + a separate test runner
- Node.js API and npm ecosystem compatibility is strong but not 100% — native addons (`node-gyp`, `.node` files) and some less common built-in modules can have edge cases
- `bunx` is the equivalent of `npx` for running package binaries without a permanent install

### Migrating from npm/yarn/pnpm to bun

```bash
# From an existing project using pnpm (or npm/yarn)
cd your-project

# Remove the old lockfile and node_modules
rm -rf node_modules pnpm-lock.yaml   # or package-lock.json / yarn.lock

# Install with bun — reads your existing package.json
bun install

# Run your existing scripts
bun run dev
```

Notes when migrating from pnpm specifically:

- `pnpm-workspace.yaml` has no bun equivalent — move workspace globs into the root `package.json` under `"workspaces"`
- pnpm's strict `node_modules` linking (which blocks importing undeclared dependencies) does not carry over — bun's install behaves more like npm/yarn in this respect
- Any pnpm-specific `.npmrc` settings won't be read by bun

### Using bun as a runtime

```bash
# Run a script directly (replaces `node file.js`)
bun file.js
bun run file.ts        # TypeScript runs natively, no ts-node needed

# Run the built-in test runner (replaces jest/vitest in simple cases)
bun test

# Bundle a project (replaces webpack/esbuild in simple cases)
bun build ./index.ts --outdir ./dist
```

Before fully removing Node.js from a machine, verify per project:

- Native addons / anything relying on `node-gyp` builds
- Less common Node built-in modules
- Framework-specific tooling (some frameworks still expect Node in production even if `bun` runs dev tooling fine)
- CI/CD and deployment targets (Docker base images, hosting platforms) actually support a bun runtime

## pip Command Cheat Sheet

| Command                            | Description                                      |
| ---------------------------------- | ------------------------------------------------ |
| `pip install <package>`            | Install a package                                |
| `pip uninstall <package>`          | Remove a package                                 |
| `pip list`                         | List installed packages                          |
| `pip show <package>`               | Show package details                             |
| `pip freeze`                       | List installed packages (for `requirements.txt`) |
| `pip search <package>`             | Search PyPI for packages                         |
| `pip install --upgrade <package>`  | Upgrade a package                                |
| `pip install -r requirements.txt`  | Install from a requirements file                 |

### Usage Notes

- Replace `<package>` with the name of the package you wish to install or manage.
- Use `pip freeze` to generate a list of dependencies for your project easily.

## poetry Command Cheat Sheet

| Command                        | Description                                                                 |
| ------------------------------ | --------------------------------------------------------------------------- |
| `poetry new <project-name>`    | Creates a new directory with a basic project structure.                     |
| `poetry init`                  | Initializes a new Poetry project in the current directory.                  |
| `poetry install`               | Installs all dependencies listed in the `pyproject.toml` file.              |
| `poetry add <package-name>`    | Adds a new package as a dependency to the project.                          |
| `poetry remove <package-name>` | Removes a package dependency from the project.                              |
| `poetry update`                | Updates all dependencies to their latest versions according to constraints. |
| `poetry run <command>`         | Runs a command in the project's virtual environment.                        |
| `poetry publish`               | Publishes the package to the Python Package Index (PyPI).                   |
| `poetry show`                  | Displays the list of installed packages and their versions.                 |
| `poetry check`                 | Checks for issues in the project including dependency vulnerabilities.      |

### Poetry Installation

```bash
curl -sSL https://install.python-poetry.org | python3 -
```

## composer Command Cheat Sheet

| Command                             | Description                                                                                                                                       |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `composer init`                     | Creates a new `composer.json` file in the current directory, prompting the user for details.                                                      |
| `composer install`                  | Installs the dependencies listed in `composer.json`, creating a `vendor` directory.                                                               |
| `composer update`                   | Updates all dependencies to the latest versions allowed by the version constraints in `composer.json`, and updates the `composer.lock` file.      |
| `composer require [package]`        | Adds a new package to the project, updates `composer.json`, and installs the package.                                                             |
| `composer remove [package]`         | Removes a package from the project, updates `composer.json`, and deletes the package files.                                                       |
| `composer show`                     | Lists all installed packages along with their versions and descriptions.                                                                          |
| `composer show [package]`           | Provides detailed information about a specific package, including its dependencies.                                                               |
| `composer dump-autoload`            | Regenerates the list of all classes that need to be included using autoloading.                                                                   |
| `composer validate`                 | Checks the `composer.json` file for syntax errors and other warnings to ensure it's valid.                                                        |
| `composer create-project [package]` | Creates a new project based on an existing package, copying its files and structure.                                                              |
| `composer global require [package]` | Installs a package globally, making it available for all projects on the system.                                                                  |
| `composer.lock`                     | This is not a command but refers to the file that locks the project dependencies at specific versions. It should be committed to version control. |
| `composer status`                   | Shows which installed packages are out of date compared to `composer.lock`.                                                                       |
| `composer config`                   | Sets configuration values for Composer, such as repositories or authentication.                                                                   |
| `composer self-update`              | Updates Composer itself to the latest version.                                                                                                    |
| `composer run-script [script]`      | Executes a defined script in the `scripts` section of `composer.json`.                                                                            |
| `composer remove [package]`         | Removes a package and updates `composer.json` accordingly.                                                                                        |

## uv Command Cheat Sheet

```bash
# Install uv globally using curl
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install uv globally using wget
wget -qO- https://astral.sh/uv/install.sh | shx

# Install uv using uv
pip install uv
```

| Command                               | Description                                            |
| ------------------------------------- | ------------------------------------------------------ |
| `uv init <project-name>`              | Creates a new directory with a basic project structure |
| `uv init --lib <project-name>`        | Initializes a new directory with a `src` folder        |
| `uv init`                             | Initializes a new uv project in the current directory  |
| `uv venv`                             | Creates a virtual environment                          |
| `uv add <package>`                    | Adds a new package as a dependency to the project      |
| `uv remove <package>`                 | Removes a package dependency from the project          |
| `uv sync`                             | Installs dependencies from pyproject.toml/uv.lock      |
| `uv sync --upgrade`                   | Update all dependencies to their latest versions       |
| `uv sync --upgrade-package <package>` | Update a specific package to its latest version        |
| `uv lock`                             | Generate/update the lock file                          |
| `uv run <command>`                    | Runs a command in the project environment              |
| `uv run main.py`                      | Runs the main script in the project                    |
| `uv add -r requirements.txt`          | Adds packages from a requirements.txt file             |
| `uv python install <version>`         | Install a specific Python version                      |
| `uv lock --upgrade`                   | Update dependencies to their latest versions           |
| `uv add --editable .`                 | Install current project in editable mode               |
| `uv sync --extra dev`                 | Install project in editable mode with dev dependencies |
| `uv python list`                      | List installed Python versions                         |
| `uv tree`                             | Lists all dependencies in the project                  |
| `uv tool install <package>`           | Install a tool globally                                |
| `uv tool list`                        | Lists all installed tools                              |
| `uv tool upgrade`                     | Updates all installed tools to their latest versions   |
| `uv build`                            | Builds the project for deployment                      |
| `uv publish`                          | Publishes the project to PyPI                          |
| `uv self update`                      | Updates uv to the latest version                       |
| `uv cache clean`                      | Clears the uv cache                                    |

## Cloning a repo that uses uv

- **Step 1: Clone the repository**

```bash
git clone <repository-url>
cd <repository-name>
```

- **Step 2: Install dependencies from pyproject.toml**

```bash
# Install uv if not already installed
curl -LsSf https://astral.sh/uv/install.sh | sh

# Create virtual environment and install dependencies
uv sync

# Or if you want to specify Python version
uv sync --python 3.11
```

- **Step 3: Activate virtual environment (optional)**

```bash
# Activate virtual environment
source .venv/bin/activate

# Or use uv run for commands (no activation needed)
uv run python main.py
```

- **Step 4: Run the FastAPI application**

```bash
# Using uv run (recommended - no venv activation needed)
uv run uvicorn main:app --reload

# Or if venv is activated
uvicorn main:app --reload
```

## Migrating from `requirements.txt` to `uv`

- **Step 1: Initialize uv project**

```bash
# Navigate to your project directory
cd your-project

# Initialize uv project (creates pyproject.toml)
uv init

# Or if you want to specify Python version
uv init --python 3.11
```

- **Step 2: Convert requirements.txt to pyproject.toml**

```bash
# Add dependencies from requirements.txt
uv add fastapi uvicorn

# Or add all at once if you have a requirements.txt
uv add -r requirements.txt
```

- **Step 3: Create virtual environment and install dependencies**

```bash
# Create and activate virtual environment
uv venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies
uv sync
```

- **Step 4: Run your FastAPI application**

```bash

# Using uv run (recommended)
uv run uvicorn main:app --reload

# Or traditional way after activating venv
uvicorn main:app --reload
```

## When to use each `sync`

### `uv sync`

- Fresh project setup from existing pyproject.toml
- Installing only production dependencies
- CI/CD pipelines, Docker builds

### `uv sync --extra dev`

- Development environment setup
- Installs main + dev dependencies (testing, linting tools)
- When pyproject.toml has [project.optional-dependencies] sections

### `uv add --editable .`

- Making your project code importable during development
- Want changes to reflect immediately without reinstalling
- Building a package/library you're actively developing

[Back to Top](#package-managers)
