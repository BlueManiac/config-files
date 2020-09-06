# Last commit
git config user.name "BlueManiac"
git config user.email "bluemaniac@users.noreply.github.com"
git commit --amend --reset-author --no-edit
git push -f

# Older commits
git config user.name "BlueManiac"
git config user.email "bluemaniac@users.noreply.github.com"
git checkout commitid
git commit --amend --reset-author --no-edit
git checkout branchname
git rebase -i newcommitid
git push --force-with-lease
