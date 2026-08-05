#!/usr/bin/env bash

commit_vocabulary_changes() {
  local WORD=$1
  
  # Check if there are any changes (tracked or untracked) in the VOCABULARY directory
  if [ -n "$(git -C "${REPO_DIR}" status --porcelain VOCABULARY/)" ]; then
    echo -e "${GREEN}Saving vocabulary data for '${WORD}'...${WHITE}"
    
    # Stage only the VOCABULARY directory
    git -C "${REPO_DIR}" add VOCABULARY/
    
    # Commit the changes with a standardized prefix
    git -C "${REPO_DIR}" commit -m "data(vocab): add '${WORD}'" --quiet
    
    # Push the changes asynchronously in the background so it doesn't block the user
    (git -C "${REPO_DIR}" push origin master --quiet >/dev/null 2>&1 &)
  fi
}
