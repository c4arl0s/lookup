#!/usr/bin/env bash

download_audio_from_google()
{
  WORD=$1
  URL="https://ssl.gstatic.com/dictionary/static/sounds/de/0"
  printf "\n${YELLOW}Downloading audio from Google Dictionary...${NC}\n"
  HTTP_CODE=$(curl -# -L -w "%{http_code}" -o "${AUDIO_DIRECTORY_PATH}/${WORD}.mp3" "${URL}/${WORD}.mp3")
  if [[ "$HTTP_CODE" == "200" ]]; then
    return 0
  else
    rm -f "${AUDIO_DIRECTORY_PATH}/${WORD}.mp3"
    return 1
  fi
}
