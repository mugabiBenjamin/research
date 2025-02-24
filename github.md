```sh
############################# Cloning and fetching

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




############################# Stagging and commiting changes

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

# Switches to the previous branch you were on.
git checkout -



############################# Undoing changes

# Switch to a specific commit
git checkout <SHA-code>

# Revert a commit by creating a new commit that undoes the changes
git revert <SHA-code>

# Reset commit history and move HEAD pointer (use with caution)
git reset <SHA-code>

# Forcefully reset to a previous commit, losing all changes after that commit
git reset --hard <SHA-code>
git push --force

# Unstage changes in a specific file that have been staged.
git reset HEAD <file>



############################# Branch management

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




############################# Configuring the default branch

# Set the default branch to 'main'
git config --global init.defaultBranch main

# Verify the default branch setting
git config --global --get init.defaultBranch




############################# README file Formatting and Indentation

Headers

   # Main Title
   ## Subtitle
   ### Sub-subtitle
   #### Level 4 Heading
   ##### Level 5 Heading
   ###### Level 6 Heading


Lists

   - Unordered list item
   - Another item
   + Another item
   * Another item

   1. Ordered list item
   2. Another item


Code blocks

   Use single backticks (```) for code blocks.
   ```bash
   # This is a bash command and a comment specifically
   npm install
   ```

```sh
   Use single backticks (`) for inline code.
   Run the `npm install` command to install dependencies.

   ( > ) for blockquotes


Links

   [Visit Google](https://google.com)
   [Jump to Installation Section](#installation)


Images

   ![GitHub Logo](https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png?raw=true)


Task List

   - [x] Completed task
   - [ ] Incomplete task


Tables

   | Column 1 | Column 2 | Column 3 |
   |----------|----------|----------|
   | Row 1    | Data 1   | Data 2   |
   | Row 2    | Data 3   | Data 4   |


Footnotes

   Here is a statement with a footnote.[^1]

   [^1]: This is the footnote text.


Collapsible section

   <details>
   <summary>Click to expand</summary>
   Hidden content goes here.
   </details>


Escaping characters

   # Won't italicize
   \*This will not italicize.*          

   # Won't create a header
   \# This will not create a header.      




############################# SSH key setup

# Generate an SSH key
ssh-keygen -t rsa -b 4096 -C "your-email"

# Start the SSH agent
eval "$(ssh-agent -s)"

# Add the SSH key to the agent
ssh-add ~/.ssh/id_rsa




############################# Forking and pull request

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




############################# Renaming and reverting changes

# Rename the last commit message
git commit --amend -m "New commit message"

# 1. Undo last commit (if not pushed)
git reset --hard HEAD~1

# 2. Force push to update commit history
git push -f




############################# Working with multiple repos

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




############################# Differentuse cases of git add

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

# y (yes): Stage this hunk.
# n (no): Do not stage this hunk.
# s (split): Split the hunk into smaller hunks, allowing you to stage parts of it.
# e (edit): Manually edit the hunk in your text editor.
# q (quit): Exit the patching process.
# ?: Display help for the interactive options.



############################# Including file in gitignore that initially wasn't

# Clear cache incase changes don't reflect on GitHub, then:
git rm -rf --cached .

git add .
git commit -m "message"

git push




############################# Starting a repo locally

mkdir <new-repo> && cd <new-repo>
git init		
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin <repo-url>
git push -u origin main




############################# Undoing things with checkout, revert, reset

# Switch to the specified commit
git checkout <SHA code>		 

# Switch back to get to present
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
git reset <SHA code> --hard	            

git push --force                

# Safer, checks that no one else has pushed changes to the remote branch since your last pull
git push --force-with-lease               

# Use git revert for shared branches (e.g., main) to avoid disrupting history.
# Use git reset for local branches or when you’re sure no one else relies on the branch, as it rewrites history.


-----------------------------------------------------

# Undo last commit to github
git reset --hard HEAD~1                         

# Undo "git reset --hard HEAD~1echo "Cloning repository..." 
git reset --hard ORIG_HEAD                      

# Rename commit mesage 2 commits back
git rebase -i HEAD~2                            
ESC > i > type `reword` > ESC > Ctrl + O > Enter > Ctrl + X   
Rewrite the commit message > ESC > Ctrl + O > Enter > Ctrl + X




############################# Cloning more than one repo (main and feature branch)

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




############################# Setting new remote urls

# Change origin url
git remote set-url origin <new-origin-url>

# Chnage upstream url
git remote set-url upstream <new-upstream-url>




############################# Change text editor that git uses for commits

# Sets the default text editor for git to VS Code.
git config --global core.editor "code --wait"

# Sets the default text editor for git to vim
git config --global core.editor "vim"

# Retrieve the currently configured default text editor for git
git config --global --get core.editor

# Open your global git configuration file in the default text editor
git config --global --edit 




############################# Pulling Changes from the Repository  

# 1. Pull changes from the remote repository, rebasing any local commits on top of the updated code  
git pull --rebase  

# 2. If you encounter a merge conflict during the rebase process, abort the rebase.  
# This will return your branch to the state before the rebase was initiated.  
git rebase --abort  

# 3. Alternatively, if rebasing is not your preferred method or you want to incorporate changes without rebasing.
git pull



############################# git pull vs git pull --rebase

# If Your Local Branch is Up to Date or Has No Conflicts: 
# If you haven't made any changes to your local branch since you last pulled
git pull --rebase

# If You Have Uncommitted Changes or Want Merge Context:
# If your local branch has changes or you want to see a clear merge history
git pull




############################# Creating, Rebasing, and Syncing a Feature Branch in Git

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




############################# Git Stash Commands  

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




############################# Git Squash

# Replace n with the number of commits you want to squash.This command will open an interactive editor showing the last n commits.
git rebase -i HEAD~n

# In the editor, you will see a list of commits. Change the word pick to `squash` (or simply s) for the commits you want to squash into the one

# After saving and closing the editor, another editor will open, prompting you to edit the commit messages.

# --------------- Squash during merge

git merge --squash <branch_name>

# Squashes commits when merging a feature branch into the main branch,
git commit -m "Your squashed commit message"

# If you're working with a publicly shared branch, like main or develop, be cautious about squashing, as it affects everyone’s history.




############################# Git worktree

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
cd ../feature-worktree
git add .
git commit -m "Adding new logic to feature"
git push origin feature/new-feature




############################# Git diff

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




############################# Git patch

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