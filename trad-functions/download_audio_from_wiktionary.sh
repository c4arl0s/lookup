#!/usr/bin/env bash

download_audio_from_wiktionary() {
  local WORD=$1
  
  # Get the media list for the word (fails silently on 404 if word not found)
  local MEDIA_LIST_JSON
  MEDIA_LIST_JSON=$(curl -sf "https://en.wiktionary.org/api/rest_v1/page/media-list/${WORD}" 2>/dev/null)
  
  if [[ -z "$MEDIA_LIST_JSON" ]]; then
    return 1
  fi
  
  # Find an audio file title. Prefer 'us' pronunciation if available, else first ogg/mp3.
  local TITLE
  TITLE=$(echo "$MEDIA_LIST_JSON" | jq -r '.items[]? | select(.type=="audio") | .title' 2>/dev/null | grep -i -E "us.*\.ogg$|us.*\.mp3$" | head -n1)
  if [[ -z "$TITLE" ]]; then
      TITLE=$(echo "$MEDIA_LIST_JSON" | jq -r '.items[]? | select(.type=="audio") | .title' 2>/dev/null | grep -i -E "\.ogg$|\.mp3$" | head -n1)
  fi
  
  if [[ -z "$TITLE" ]]; then
    return 1
  fi
  
  # Get the direct download URL for the file from Wikipedia's Action API
  local URL_JSON
  URL_JSON=$(curl -sf "https://en.wiktionary.org/w/api.php?action=query&titles=${TITLE}&prop=imageinfo&iiprop=url&format=json" 2>/dev/null)
  
  local DOWNLOAD_URL
  DOWNLOAD_URL=$(echo "$URL_JSON" | jq -r '.query.pages[].imageinfo[0].url' 2>/dev/null)
  
  if [[ -z "$DOWNLOAD_URL" || "$DOWNLOAD_URL" == "null" ]]; then
    return 1
  fi
  
  local FILE_NAME="${WORD}.mp3"
  
  printf "\n${YELLOW}Downloading audio from Wiktionary...${NC}\n"
  HTTP_CODE=$(curl -# -L -w "%{http_code}" -o "$FILE_NAME" "$DOWNLOAD_URL")
  if [[ "$HTTP_CODE" == "200" ]]; then
    mv "$FILE_NAME" "$AUDIO_DIRECTORY_PATH/"
    return 0
  else
    rm -f "$FILE_NAME"
    return 1
  fi
}
