#!/bin/bash
OLD_NAME=""
OLD_EMAIL=""
NEW_NAME="Y W"
NEW_EMAIL="neverset123@users.noreply.github.com"

Rewrite the commit history
git filter-repo --force --commit-callback '
if commit.author_name == b"'"${OLD_NAME}"'" or commit.author_email == b"'"${OLD_EMAIL}"'":
    commit.author_name = b"'"${NEW_NAME}"'"
    commit.author_email = b"'"${NEW_EMAIL}"'"
if commit.committer_name == b"'"${OLD_NAME}"'" or commit.committer_email == b"'"${OLD_EMAIL}"'":
    commit.committer_name = b"'"${NEW_NAME}"'"
    commit.committer_email = b"'"${NEW_EMAIL}"'"
'
git remote add origin https://github.com/neverset123/YWHome.git
git push --force --set-upstream origin master
echo "Commit history updated"