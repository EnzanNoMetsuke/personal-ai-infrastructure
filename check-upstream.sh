#!/bin/bash
#
# Check the upstream repo for changes without actually fetching them.

local_ref=$(git rev-parse upstream/main) &&
remote_ref=$(git ls-remote upstream refs/heads/main | cut -f1) &&
if [ "$local_ref" != "$remote_ref" ]; then
  echo "Upstream has new commits."
else
  echo "Upstream is up to date."
fi
