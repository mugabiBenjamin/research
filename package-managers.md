# yarn vs npm

- [npm vs Yarn Command Comparison](#npm-vs-yarn-command-comparison)
- [pip Command Cheat Sheet](#pip-command-cheat-sheet)

## npm vs Yarn Command Comparison

| npm Command                         | Yarn Command                         |  
|-------------------------------------|--------------------------------------|  
| `npm install <package>`             | `yarn add <package>`                 |  
| `npm uninstall <package>`           | `yarn remove <package>`              |  
| `npm install`                       | `yarn install` (or just `yarn`)      |  
| `npm update`                        | `yarn upgrade`                       |  
| `npm list`                          | `yarn list`                          |  
| `npm run <script-name>`             | `yarn <script-name>`                 |  
| `npm init`                          | `yarn init`                          |  
| `npm update <package>`              | `yarn upgrade <package>`             |  
| `package-lock.json`                 | `yarn.lock`                          |  

### Key Differences

- **Lock Files**: `npm` uses `package-lock.json` to lock down the versions of a package's dependencies, while `yarn` uses `yarn.lock`.  
- **Speed**: Yarn generally performs installations faster than npm because it caches every package it downloads.  
- **Workspaces**: Yarn supports workspaces to manage monorepos, which can simplify the management of multiple packages in a single repository.  

## pip Command Cheat Sheet  

| Command                               | Description                              |  
|---------------------------------------|------------------------------------------|  
| `pip install <package>`               | Install a package                        |  
| `pip uninstall <package>`             | Remove a package                         |  
| `pip list`                            | List installed packages                  |  
| `pip show <package>`                  | Show package details                     |  
| `pip freeze`                          | List installed packages (for `requirements.txt`) |  
| `pip search <package>`                | Search PyPI for packages                 |  
| `pip install --upgrade <package>`     | Upgrade a package                        |  
| `pip install -r requirements.txt`     | Install from a requirements file        |  

### Usage Notes

- Replace `<package>` with the name of the package you wish to install or manage.  
- Use `pip freeze` to generate a list of dependencies for your project easily.
