# Package Managers

- [npm vs Yarn Command Comparison](#npm-vs-yarn-command-comparison)
- [pip Command Cheat Sheet](#pip-command-cheat-sheet)
- [composer Command Cheat Sheet](#composer-command-cheat-sheet)
- [uv Command Cheat Sheet](#uv-command-cheat-sheet)

## npm vs Yarn Command Comparison

| npm Command               | Yarn Command                    |
| ------------------------- | ------------------------------- |
| `npm install <package>`   | `yarn add <package>`            |
| `npm uninstall <package>` | `yarn remove <package>`         |
| `npm install`             | `yarn install` (or just `yarn`) |
| `npm update`              | `yarn upgrade`                  |
| `npm list`                | `yarn list`                     |
| `npm run <script-name>`   | `yarn <script-name>`            |
| `npm init`                | `yarn init`                     |
| `npm update <package>`    | `yarn upgrade <package>`        |
| `package-lock.json`       | `yarn.lock`                     |

### Yarn Installation

```bash
npm install -g yarn  # Install Yarn globally
```

### Key Differences

- **Lock Files**: `npm` uses `package-lock.json` to lock down the versions of a package's dependencies, while `yarn` uses `yarn.lock`.
- **Speed**: Yarn generally performs installations faster than npm because it caches every package it downloads.
- **Workspaces**: Yarn supports workspaces to manage monorepos, which can simplify the management of multiple packages in a single repository.

## pip Command Cheat Sheet

| Command                           | Description                                      |
| --------------------------------- | ------------------------------------------------ |
| `pip install <package>`           | Install a package                                |
| `pip uninstall <package>`         | Remove a package                                 |
| `pip list`                        | List installed packages                          |
| `pip show <package>`              | Show package details                             |
| `pip freeze`                      | List installed packages (for `requirements.txt`) |
| `pip search <package>`            | Search PyPI for packages                         |
| `pip install --upgrade <package>` | Upgrade a package                                |
| `pip install -r requirements.txt` | Install from a requirements file                 |

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
| `composer validate`                 | Checks the `composer.json` file for syntax errors and other warnings to ensure it’s valid.                                                        |
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
```
