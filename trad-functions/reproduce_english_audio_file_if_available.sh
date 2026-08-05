#!/usr/bin/env bash

reproduce_english_audio_file_if_available() {
  WORD=$1
  if $(is_retrievable_english_audio ${WORD})
  then
    reproduce_audio ${WORD}
  else
    if ! download_word_audio -w ${WORD}; then
      if ! download_audio_from_google ${WORD}; then
        if ! download_audio_from_wiktionary ${WORD}; then
          download_audio_from_google_tts ${WORD}
        fi
      fi
    fi
    convert_mp3_to_wav ${WORD}
    reproduce_audio ${WORD}
  fi
}
