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
git push -u origin feature/<feature_branch_name>

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

```