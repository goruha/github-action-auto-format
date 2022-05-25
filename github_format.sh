#!/bin/bash

set -x

echo "Copying workflows from cloudposse/.github repo"

mkdir gha_tmp_dir
cd gha_tmp_dir
git clone https://github.com/cloudposse/.github

# if this is the cloudposse/github-action-auto-format repository, don't copy the version of auto-format.yml from cloudposse/.github - it should be different
if [ "$(basename `git rev-parse --show-toplevel`)" == "github-action-auto-format" ]; then
  rm ./.github/.github/workflows/auto-format.yml
else
  echo "$(basename `git rev-parse --show-toplevel`)"
fi

cp ./.github/.github/workflows/*.yml ../.github/workflows/
cd ..
rm -rf ./gha_tmp_dir

git config --global --add safe.directory /github/workspace
git config --local user.name "${BOT_NAME}"
git config --local user.email "11232728+${BOT_NAME}@users.noreply.github.com"
git add ./.github/workflows/*
# Don't try committing without any files staged. That returns a non-zero exit code.
if ! git diff --staged --exit-code; then
  git commit -m "Adding .github files"
fi
