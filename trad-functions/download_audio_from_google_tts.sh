#!/usr/bin/env bash

download_audio_from_google_tts() {
  local WORD=$1
  echo "Using Google Translate TTS API to download audio for $WORD"
  
  local FILE_NAME="${WORD}.mp3"
  local DOWNLOAD_URL="https://translate.google.com/translate_tts?ie=UTF-8&q=${WORD}&tl=en&client=tw-ob"
  
  echo "Downloading pronunciation for \"$WORD\" from Google TTS..."
  
  if curl -sSfL -o "$FILE_NAME" "$DOWNLOAD_URL"; then
    echo "Saved to $FILE_NAME"
    mv "$FILE_NAME" "$AUDIO_DIRECTORY_PATH/"
    return 0
  else
    echo "Failed to download audio for \"$WORD\" from Google TTS"
    rm -f "$FILE_NAME"
    return 1
  fi
}
