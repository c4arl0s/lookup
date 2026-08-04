#!/usr/bin/env bash

reproduce_audio()
{
    WORD=$1
    echo -e "${WHITE}"
    if [[ -f ${AUDIO_DIRECTORY_PATH}/${WORD}.wav ]]; then 
        play ${AUDIO_DIRECTORY_PATH}/${WORD}.wav
    elif [[ -f ${AUDIO_DIRECTORY_PATH}/${WORD}.mp3 ]]; then
        if command -v afplay >/dev/null 2>&1; then
            afplay ${AUDIO_DIRECTORY_PATH}/${WORD}.mp3
        else
            play ${AUDIO_DIRECTORY_PATH}/${WORD}.mp3
        fi
    else 
        echo -e "${RED}I could not find ${WHITE}${WORD} ${RED}audio file"
    fi
}
