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
  
  # Fetch JSON data silently
  API_URL="https://api.dictionaryapi.dev/api/v2/entries/en/${WORD}"
  JSON=$(curl -sf "$API_URL")
  
  # Extract the first non‑empty audio URL using jq
  AUDIO_URL=$(echo "$JSON" |
    jq -r '.[]?.phonetics[]?.audio // empty' |
    grep -v '^$' |
    head -n1)
  
  if [[ -z "$AUDIO_URL" ]]; then
    return 1
  fi
  
  local FILE_NAME="${WORD}.mp3"
  
  printf "\n${YELLOW}Downloading audio from DictionaryAPI...${NC}\n"
  HTTP_CODE=$(curl -# -L -w "%{http_code}" -o "$FILE_NAME" "$AUDIO_URL")
  if [[ "$HTTP_CODE" == "200" ]]; then
    mv "$FILE_NAME" "$AUDIO_DIRECTORY_PATH/"
  else
    rm -f "$FILE_NAME"
    return 1
  fi
}
