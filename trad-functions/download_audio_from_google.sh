#!/usr/bin/env bash

download_audio_from_google()
{
  WORD=$1
  printf "\n${YELLOW}Trying Downloading from google"
  URL="https://ssl.gstatic.com/dictionary/static/sounds/de/0"
  if wget -q --spider ${URL}/${WORD}.mp3 && wget -q -c ${URL}/${WORD}.mp3 -O ${AUDIO_DIRECTORY_PATH}/${WORD}.mp3 
  then
    printf "\n${GREEN}downloading mp3 file ...\n"
    return 0
  else 
    printf "\n${RED}URL is down, try other mean\n"
    return 1
  fi
}
