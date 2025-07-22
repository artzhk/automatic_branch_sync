#!/bin/bash

# List all feature branches (use a prefix if desired)
feature_branches=$(git branch -r | grep 'origin/feature' | sed 's/origin\///')

# Loop over each feature branch and merge/rebase
for branch in $feature_branches; do
    echo "Syncing branch $branch"
    git checkout $branch

    if [[ -z $(git diff origin/dev) ]]; then 
      echo "Nothing to merge for branch $branch. Skipping..."
      continue
    fi

    git merge origin/dev --no-ff -m "Automatic sync with dev branch"

    if [[ $? -ne 0 ]]; then 
      git merge --abort
      echo "Merge Conflict" 
      echo "Merge Conflict on $(date) in $branch" >> conflict_log.txt
      git add conflict_log.txt && git commit -m "Conflict during merge" && git push
      continue
    fi

    # Optional: Push the merged branch
    # git push

    echo "Successfully synced branch $branch"
done

# Test changes 21/07/2025

echo "Sync process completed."
