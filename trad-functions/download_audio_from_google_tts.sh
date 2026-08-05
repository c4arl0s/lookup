#!/usr/bin/env bash

download_audio_from_google_tts() {
  local WORD=$1
  
  local FILE_NAME="${WORD}.mp3"
  local DOWNLOAD_URL="https://translate.google.com/translate_tts?ie=UTF-8&q=${WORD}&tl=en&client=tw-ob"
  
  printf "\n${YELLOW}Generating and downloading audio from Google Translate TTS...${NC}\n"
  HTTP_CODE=$(curl -# -L -w "%{http_code}" -o "$FILE_NAME" "$DOWNLOAD_URL")
  if [[ "$HTTP_CODE" == "200" ]]; then
    mv "$FILE_NAME" "$AUDIO_DIRECTORY_PATH/"
    return 0
  else
    rm -f "$FILE_NAME"
    return 1
  fi
}
