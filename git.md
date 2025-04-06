# Git commands

- [Cloning and fetching](#cloning-and-fetching)
- [Stagging and commiting changes](#stagging-and-commiting-changes)
- [Undoing changes](#undoing-changes)
- [Branch management](#branch-management)
- [Configuring the default branch](#configuring-the-default-branch)
- [SSH key setup](#ssh-key-setup)
- [Forking and pull requests](#forking-and-pull-requests)
- [Working with multiple repos](#working-with-multiple-repos)
- [Different use cases of git add](#different-use-cases-of-git-add)
- [Including file in gitignore that initially wasn't](#including-file-in-gitignore-that-initially-wasnt)
- [Starting a repo locally](#starting-a-repo-locally)
- [Undoing things with checkout, revert, reset](#undoing-things-with-checkout-revert-reset)
- [Cloning more than one repo (main and feature branch)](#cloning-more-than-one-repo-main-and-feature-branch)
- [Setting new remote urls](#setting-new-remote-urls)
- [Pulling Changes from the Repository](#pulling-changes-from-the-repository)
- [git pull vs git pull --rebase](#git-pull-vs-git-pull---rebase)
- [Creating, Rebasing, and Syncing a Feature Branch in git](#creating-rebasing-and-syncing-a-feature-branch-in-git)
- [Git Stash Commands](#git-stash-commands)
- [Git Squash](#git-squash)
- [Git worktree](#git-worktree)
- [Git diff](#git-diff)
- [Git patch](#git-patch)
- [Git cherry-pick](#git-cherry-pick)
- [Git reflog](#git-reflog)
- [Git blame](#git-blame)

## Cloning and fetching

```sh
# Clone a repository into a folder on your local machine
git clone <repository_url>

# Clone a repository into a specific folder name
git clone <repository_url> <folder_name>

# Pull changes from the remote repository to the local machine
git pull

# Fetch updates from a remote repository without merging
git fetch

# Merge fetched updates into the working directory
git merge
```

## Stagging and commiting changes

```sh
# Track all changes (new, modified, deleted files)
git add .

# Track a specific file
git add <filename>

# Commit changes with a descriptive message
git commit -m "Commit message here"

# Push committed changes to the remote repository
git push
# First push in a local repo use git push -u origin main

# Stages and commits existing tracked files (does apply after adding a file, use `git add` first)
git commit -am "Commit message"

# Modifies the most recent commit in your git repository without changing the commit message
# Use when you have made changes but forgot to include them in your last commit.
# Works best if you haven't push changes to remote repo

git commit -a --amend --no-edit           # Rewrites history if changes had already been pushed
git push --force

# Rename the last commit message
git commit --amend -m "New commit message"

# Switches to the previous branch you were on.
git checkout -
```

## Undoing changes

```sh
# Switch to a specific commit
git checkout <SHA-code>

# Revert a commit by creating a new commit that undoes the changes
git revert <SHA-code>

# Reset commit history and move HEAD pointer (use with caution)
git reset <SHA-code>

# Forcefully reset to a previous commit, losing all changes after that commit
git reset --hard <SHA-code>
git push --force
```

## Branch management

```sh
# Create a new branch
git branch <branch-name>

# Switch to an existing branch
git checkout <branch-name>

# Creates and switches to a new branch with the specified <branch-name>
git checkout -b <branch-name>

# Rename a branch
git branch -m <new-branch-name>

# Delete a branch locally
git branch -d <branch-name>

# Delete a branch remotely
git push origin --delete <branch-name>
```

## Configuring the default branch

```sh
# Set the default branch to 'main'
git config --global init.defaultBranch main

# Verify the default branch setting
git config --global --get init.defaultBranch

# Sets the default text editor for git to VS Code.
git config --global core.editor "code --wait"

# Sets the default text editor for git to vim
git config --global core.editor "vim"

# Retrieve the currently configured default text editor for git
git config --global --get core.editor

# Open your global git configuration file in the default text editor
git config --global --edit

# Set the user name
git config --global user.name "Your Name"

# Set the user email
git config --global user.email example@gmail.com

```

## SSH key setup

```sh
# Generate an SSH key
ssh-keygen -t rsa -b 4096 -C "your-email"

# Start the SSH agent
eval "$(ssh-agent -s)"

# Add the SSH key to the agent
ssh-add ~/.ssh/id_rsa
```

## Forking and pull requests

```sh
# 1. Clone the forked repository
git clone <repository_url>

# 2. Add the original repository as a remote
git remote add upstream <original_repository_url>
git remote -v

# 3. Create a new branch for the feature
git checkout -b feature/<feature_branch_name>

# 4. Stage and commit changes
git add .
git commit -m "Feature added"

# 5. Push to the feature branch
git push origin feature/<feature_branch_name>

# 6. Create pull request from original repo

# 7. Switch to the main branch
git checkout main

# 8. Fetch changes from the original repository
git fetch upstream
git merge upstream/main

# 9. Push changes to the main branch of the fork
git push origin main

# 10. Delete feature branch locally
   git branch -d <feature_branch_name>

   # Delete feature branch locally forcefully regardless of whether it has been merged or not.
   git branch -D <feature_branch_name>

# 11. Delete feature branch remotely
git push origin --delete <feature_branch_name>
```

## Working with multiple repos

```sh
# Clone a repository
git clone <repo_url>

# Fetch all branches
git fetch --all

# List all local branches
git branch

# List all remote branches
git branch -a

# Checkout a remote branch
git checkout <branch_name>
```

## Different use cases of git add

```sh
# Add all changes, including new and deleted files
git add .

# Add all changes, similar to `git add .`
git add --all

# Add a specific file
git add <filename>

# Add modified files but not new ones
git add -u

# Add only non-hidden files
git add *

# Allows you to interactively stage changes from your working directory
git add --patch or git add -p

# Unstaged particular changes
git reset -p

# Unstage all changes
git reset

# y - Yes, stage this hunk
# n - No, don't stage this hunk
# q - Quit; don't stage this hunk or any remaining hunks
# a - Stage this hunk and all later hunks in the file
# d - Don't stage this hunk or any later hunks in the file
# j - Leave this hunk undecided, see next undecided hunk
# J - Leave this hunk undecided, see next hunk
# g - Select a hunk to go to
# / - Search for a hunk matching the given regex
# s - Split the current hunk into smaller hunks
# e - Manually edit the current hunk
# p - Print the current hunk again
# ? - Print help information about these commands
```

## Including file in gitignore that initially wasn't

```sh
# Clear cache incase changes don't reflect on GitHub, then:
git rm -rf --cached .

git add .
git commit -m "message"

git push
```

## Starting a repo locally

```sh
mkdir <new-repo> && cd <new-repo>
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin <repo-url>
git push -u origin main
```

## Undoing things with checkout, revert, reset

```sh
# 1. Switch to the specified commit
git checkout <SHA code>

# 2. Switch back to get to present
git checkout main

# Creates a new commit that undoes the changes introduced by the specified commit.
git revert <SHA code>

# To undo a git revert
git revert <SHA-of-the-revert-commit>

-----

# Moves the HEAD pointer to a specific commit (<SHA>), altering your commit history.
git reset <SHA code>

# To recover git reset
git add .
git commit -m "undo reset"

----

# Removes commits, can't be gotten back
git reset --hard <SHA code>
git push --force

# Safer, checks that no one else has pushed changes to the remote branch since your last pull
git push --force-with-lease

# Use git revert for shared branches (e.g., main) to avoid disrupting history.
# Use git reset for local branches or when you’re sure no one else relies on the branch, as it rewrites history.

-----------------------------------------------------

# Undo last commit to github
git reset --hard HEAD~1 or git reset --hard HEAD^

# Undo "git reset --hard HEAD~1echo "Cloning repository..."
git reset --hard ORIG_HEAD

# Restores the file to the last committed state undoing uncommitted changes
git restore file_name || git checkout -- file_name || git checkout HEAD file_name
```

## Cloning more than one repo (main and feature branch)

```sh
git clone <URL-of-your-forked-repo>

# Fetch all branches
git fetch --all

# List all local branches
git branch

# List all remote branches
git branch -a

# Switch to feature branch
git checkout <feature_branch_name>

git checkout main
git pull origin main

git checkout <feature_branch_name>
git pull origin <feature_branch_name>
```

## Setting new remote urls

```sh
# Change origin url
git remote set-url origin <new-origin-url>

# Chnage upstream url
git remote set-url upstream <new-upstream-url>
```

## Pulling Changes from the Repository

```sh
# 1. Pull changes from the remote repository, rebasing any local commits on top of the updated code
git pull --rebase

# 2. If you encounter a merge conflict during the rebase process, abort the rebase.
# This will return your branch to the state before the rebase was initiated.
git rebase --abort

# 3. Alternatively, if rebasing is not your preferred method or you want to incorporate changes without rebasing.
git pull
```

## git pull vs git pull --rebase

```sh
# If Your Local Branch is Up to Date or Has No Conflicts:
# If you haven't made any changes to your local branch since you last pulled
git pull --rebase

# If You Have Uncommitted Changes or Want Merge Context:
# If your local branch has changes or you want to see a clear merge history
git pull
```

## Creating, Rebasing, and Syncing a Feature Branch in git

```sh
# 1. Create a new branch for your feature or changes
git checkout -b my-feature-branch

# 2. Staging and committing changes
git add .
git commit -m "Describe your changes here"

# 3. Fetch the latest changes from the upstream repository
git fetch upstream

# 4. Rebase your current branch on top of the latest changes from upstream/main
git rebase upstream/main

# 5. If you encounter conflicts during the rebase process, stage the resolved files
git add <file-with-conflicts>

# 6. Continue the rebase process after resolving conflicts
git rebase --continue

# 7. Push the rebased changes to your forked repository, forcing the update
git push origin my-feature-branch --force

# 8. Switch back to the main branch
git checkout main

# 9. Fetching and merging changes into your local main branch
git fetch upstream
git merge upstream/main

# 10. Push the updated main branch to your forked repository
git push origin main
```

## Git Stash Commands

```sh
# Stash your current changes (modified tracked files and the index)
git stash

# Stash changes with a message for later reference
git stash push -m "Your message here"

# List all stashed changes along with their identifiers
git stash list

# Apply the most recent stash to your working directory
git stash apply

# Apply a specific stash by referencing its index (e.g., second stash)
git stash apply stash@{1}

# Remove a specific stash from the list (e.g., remove the first stash)
git stash drop stash@{0}

# Clear all stashes from your stash list
git stash clear

# Apply the most recent stash and remove it from the stash list
git stash pop

# Stash untracked files in addition to tracked files
git stash push -u

# Stash all files, including ignored files
git stash push -a

# Create a new branch from the latest stash and apply it
git stash branch new-branch-name
```

## Git Squash

```sh
# Replace n with the number of commits you want to squash.This command will open an interactive editor showing the last n commits.
git rebase -i HEAD~n

# In the editor, you will see a list of commits. Change the word pick to `squash` (or simply s) for the commits you want to squash into the one
# After saving and closing the editor, another editor will open, prompting you to edit the commit messages.

# Rename commit mesage 2 commits back (using Nano)
git rebase -i HEAD~2
ESC > i > type `reword` > ESC > Ctrl + O > Enter > Ctrl + X
Rewrite the commit message > ESC > Ctrl + O > Enter > Ctrl + X

======================================= Squash during merge

git merge --squash <branch_name>

# Squashes commits when merging a feature branch into the main branch,
git commit -m "Your squashed commit message"

# If you're working with a publicly shared branch, like main or develop, be cautious about squashing, as it affects everyone’s history.
```

## Git worktree

```sh
# Creating a new worktree
git worktree add <path> <branch>
git worktree add ../new-feature feature/awesome-feature

# The `feature/awesome-feature` branch must already exist in your repository
# You can run this command while on any branch (including main),
# as long as the `feature/awesome-feature` branch has already been created in your Git repository.

#  Listing Worktrees
git worktree list

# Removing a Worktree
git worktree remove <path>
git worktree remove ~/Desktop/Projects/new-feature

# Steps
git checkout feature/new-feature
git worktree add ../feature-worktree feature/new-feature
code ../feature-worktree
git add .
git commit -m "Adding new logic to feature"
git push origin feature/new-feature
```

## Git diff

```sh
# To see changes in your working directory that are not yet staged for commit
git diff

# To see changes that have been staged but are not yet committed
git diff --staged

# -w means ignore white spaces
git diff -w --staged

# To compare changes between two commits
git diff commit1 commit2

# To see differences between your current branch and another branch
git diff branch_name

# Shows only the names of files that have changed, without showing the actual content differences
git diff --name-only

# Gives a summary of changes, showing how many lines were added or deleted for each file
git diff --stat

# compare the contents of two files or directories that are not part of a Git repository
git diff --no-index fileA.txt fileB.txt

# Highlight differences at the word level instead of line level
git diff --word-diff

# Show differences between the current branch and the previous commit
git diff HEAD~1
```

## Git patch

```sh
# To create a patch file
git diff > my_changes.patch

# To create a patch file of staged changes
git diff --cached > my_changes.patch

# To create individual patch files for the last three commits
git format-patch HEAD~3..HEAD

# To apply a patch
git apply my_changes.patch

# To apply a patch and also create a new commit
git am my_changes.patch
```

## Git cherry-pick

```sh
# To cherry-pick a commit
git cherry-pick <commit_hash>

# To cherry-pick a commit and also create a new commit
git cherry-pick <commit_hash> -c

# To cherry-pick a commit and also create a new commit with a custom commit message
git cherry-pick <commit_hash> -c -m "Custom commit message"

# To cherry-pick a commit and also create a new commit with a custom commit message and author
git cherry-pick <commit_hash> -c -m "Custom commit message" -a "Custom author"

# To cherry-pick multiple commits
git cherry-pick <commit-hash1> <commit-hash2>

# To cherry-pick a range of commits
git cherry-pick <start-hash>^..<end-hash>

# To continue cherry-picking after resolving conflicts
git cherry-pick --continue

# To abort cherry-picking
git cherry-pick --abort
```

## Git reflog

```sh
# To see a list of actions that have updated the HEAD reference
git reflog

# Recovering a Lost Commit
git checkout -b recovered-branch HEAD@{1}

# Resets your current branch to the state it was in 2 entries ago in the reflog
git reset --hard HEAD@{2}

# Creates and switches to the feature branch at that commit, effectively branching off from that point in history
git checkout -b feature-branch bfd054a
```

## Git blame

```sh
# To see who last modified a specific file
git blame file.txt

# To see who last modified a specific range of lines
git blame -L 1,10 file.txt

# Ignore whitespace changes
git blame -w file.txt

# To show line numbers
git blame -n calculator.py

# To ignore a specific commit
git blame --ignore-rev <commit_hash> path/to/file.txt

# Detect moved lines within the same file
git blame -M calculator.py

# Detect lines moved/copied from other files
git blame -C calculator.py

# Ignore whitespace, detects moved/copied lines, and focuses just on the function in question.
git blame -w -C -M -L 100,150 complex_function.py

# Detect lines moved within the same file (For deeper investigation)
git log -L 42,42:file.py
```

[Back to top](#git-commands)
