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
    
    # Get the current hour in Central Time (00-23)
    local CURRENT_HOUR=$(TZ="America/Chicago" date +%H)
    
    # Only push if it is 6 PM (18:00) or later in Central Time
    if [ "$CURRENT_HOUR" -ge 18 ]; then
      (git -C "${REPO_DIR}" push origin master --quiet >/dev/null 2>&1 &)
    fi
  fi
}
