#!/usr/bin/env bash
# Downloads the first available pronunciation audio (US) for the given English word
# Requires: curl, jq (both typically pre‑installed on macOS via Homebrew)

download_word_audio()
{
  # Parse arguments: allow either a positional word or -w/--word flag
  if [[ $# -eq 0 ]]; then
    echo "Usage: $0 [-w|--word] <word>"
    return 1
  fi
  
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -w|--word)
        if [[ -n "$2" ]]; then
          WORD="$2"
          shift 2
          continue
        else
          echo "Error: -w|--word requires a value"
          exit 1
        fi
        ;;
      *)
        WORD="$1"
        shift
        ;;
    esac
    done
  
  echo "Using dictionaryapi API to download $1"
  API_URL="https://api.dictionaryapi.dev/api/v2/entries/en/${WORD}"
  
  if curl -sSf "$API_URL"; then
    echo "Success: Curl returned 0"
  else
    echo "Failure: Curl returned $?"
    return 1 
  fi
  
  # Fetch JSON data
  JSON=$(curl -sSf "$API_URL")
  
  # Extract the first non‑empty audio URL using jq
  AUDIO_URL=$(echo "$JSON" |
    jq -r '.[]?.phonetics[]?.audio // empty' |
    grep -v '^$' |
    head -n1)
  
  if [[ -z "$AUDIO_URL" ]]; then
    echo "No audio pronunciation found for \"$WORD\""
    return 1
  fi
  
  FILE_NAME="${WORD}.mp3"
  
  echo "Downloading pronunciation for \"$WORD\"..."
  if curl -sSfL -o "$FILE_NAME" "$AUDIO_URL"; then
    echo "Saved to $FILE_NAME"
    mv "$FILE_NAME" "$AUDIO_DIRECTORY_PATH/"
  else
    echo "Failed to download audio for \"$WORD\""
    rm -f "$FILE_NAME"
    return 1
  fi
}
