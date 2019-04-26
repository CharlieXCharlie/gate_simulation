# Git
## Install Git on Linux
$ git
### Debian or Ubuntu Linux
$ sudo apt-get install git

### Max OS X
- Xcode->Preferences
- Downloads
- Coommand line tools -> install

### Windows
https://git-scm.com/downloads
After install:
$ git config --global user.name "CharlieXCharlie"
$ git conifg --global user.email "luqiqi@icloud.com"

## Create repository
$ mkdir name
$ cd name
<!-- $ pwd -->
$ git init
<!-- ls -ah -->

## Test Commit
### First Commit 
$ git add file1.md
<!-- $ git add file2.md -->
<!-- $ git add file1.md file2.md -->
$ git commit -m "wrote a file"

### After midification
$ git status
$ git diff
<!-- $ git diff HEAD --file -->
$ git add file
<!-- $ git status -->
$ git commit -m "midification"
<!-- $ git status -->

### Review History
$ git log
$ git log --pretty=oneline

### Redo Commits
#### Redo previous one
$ git reset --hard HEAD^
<!-- $ git reset --hard HEAD^^^^^ -->
#### Go to Specified commit
<!-- $ git log -->
<!-- $ git reflog -->
$ git reset --hard 1094a
#### Discard cahnges in working directory
$ git checkout -- file
#### Unstage file in the stage
$ git reset HEAD file 
$ git checkout -- file

### Remove
$ rm file
<!-- $ git status -->
$ git rm file
$ git commit -m "message"
<!-- $ git checkout --file -->

## GitHub
### Create SSH Key
$ ssh-keygen -t rsa -C "luqiqi8200@icloud.com"
### Set in GitHub
- Sign in
- Account setting -> SSH Key
- Add SSH Key
- Paste id_rsa.pub

### Create repo
- sign in
- create a new repo
- insert name
- "create repository"

### Link repo to local
$ git remote add origin git@hub.com:CharlieXCharlie/gate_code.git
<!-- $ git remote -->
<!-- $ git remote -v -->

### Push
$ git push -u origin master
<!-- $ git push origin master -->
<!-- $ git push origin dev -->

### Clone
$ git clone git@github.com:CharlieXCharlie/gate_code.git

## Branch
### create and switch to a new branch
$ git checkout -b dev
<!-- $ git branch dev -->
<!-- $ git checkout dev -->
### check branch
$ git branch

### merge
$ git checkout master
$ git merge dev
<!-- $ git merge --no-ff -m "merge with no_FastForward" dev -->


### delete branch
$ git branch -d dev
<!-- $ git branch -->
<!-- $ git branch -D dev -->

### conflicts
$ git status
- modify file in master
$ git add file
$ git commit -m "message"
$ git log --graph --pretty=oneline --abbrev-commit
$ git branch -d feature1

### Bug
Now in dev branch
$ git status
$ git stash
$ git checkout master
$ git checkout -b issue-101
$ git add file
$ git commit -m "message"
$ git checkout master
$ git merge --no-ff -m "message" issue-101
$ git checkout dev
$ git status
$ git stash list
<!-- $ git stash apply stash@{0} -->
<!-- $ git stash drop stash@{0} -->
$ git stash pop
<!-- $ git stash list -->

## Pull
$ git clone git@github.com:CharlieXCharlie/gate_code.git
<!-- $ git branch -->
$ git checkout -b dev origin/dev
$ git add file
$ git commit -m "message"
$ git push origin dev

<!-- when rejected -->
<!-- $ git pull -->
$ git branch --set-upstream-to=origin/dev dev
$ git pull
- fix comflict
$ git commit -m "fix"
$ git push origin dev

