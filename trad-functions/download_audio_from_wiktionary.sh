#!/usr/bin/env bash

download_audio_from_wiktionary() {
  local WORD=$1
  echo "Using Wiktionary API to download audio for $WORD"
  
  # Get the media list for the word (fails silently on 404 if word not found)
  local MEDIA_LIST_JSON
  MEDIA_LIST_JSON=$(curl -sSf "https://en.wiktionary.org/api/rest_v1/page/media-list/${WORD}" 2>/dev/null)
  
  if [[ -z "$MEDIA_LIST_JSON" ]]; then
    echo "No media found on Wiktionary for $WORD"
    return 1
  fi
  
  # Find an audio file title. Prefer 'us' pronunciation if available, else first ogg/mp3.
  local TITLE
  TITLE=$(echo "$MEDIA_LIST_JSON" | jq -r '.items[]? | select(.type=="audio") | .title' 2>/dev/null | grep -i -E "us.*\.ogg$|us.*\.mp3$" | head -n1)
  if [[ -z "$TITLE" ]]; then
      TITLE=$(echo "$MEDIA_LIST_JSON" | jq -r '.items[]? | select(.type=="audio") | .title' 2>/dev/null | grep -i -E "\.ogg$|\.mp3$" | head -n1)
  fi
  
  if [[ -z "$TITLE" ]]; then
    echo "No audio pronunciation found on Wiktionary for $WORD"
    return 1
  fi
  
  # Get the direct download URL for the file from Wikipedia's Action API
  local URL_JSON
  URL_JSON=$(curl -sSf "https://en.wiktionary.org/w/api.php?action=query&titles=${TITLE}&prop=imageinfo&iiprop=url&format=json" 2>/dev/null)
  
  local DOWNLOAD_URL
  DOWNLOAD_URL=$(echo "$URL_JSON" | jq -r '.query.pages[].imageinfo[0].url' 2>/dev/null)
  
  if [[ -z "$DOWNLOAD_URL" || "$DOWNLOAD_URL" == "null" ]]; then
    echo "Failed to get download URL from Wiktionary for $WORD"
    return 1
  fi
  
  local FILE_NAME="${WORD}.mp3"
  echo "Downloading pronunciation for \"$WORD\" from Wiktionary..."
  
  if curl -sSfL -o "$FILE_NAME" "$DOWNLOAD_URL"; then
    echo "Saved to $FILE_NAME"
    mv "$FILE_NAME" "$AUDIO_DIRECTORY_PATH/"
    return 0
  else
    echo "Failed to download audio for \"$WORD\" from Wiktionary"
    rm -f "$FILE_NAME"
    return 1
  fi
}
