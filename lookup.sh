#!/usr/bin/env bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
REPO_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
. "${REPO_DIR}/directory_paths.sh"

# The history logic and loop are moved into a subshell below to prevent
# script commands from being recorded and to avoid polluting the environment.

readonly NO_ARGUMENTS_MSG="\n${WHITE}You should not provide any argument in this script, you just type trad3"
readonly AVAILABILITY_MSG="\n${WHITE}${WORD} ${GREEN}is available in english data base" 
readonly DOES_NOT_EXIST_ENG_MSG="\n${WHITE}${WORD} ${RED}does not exist on english data base .... now looking into spanish data base"
readonly DOES_NOT_EXIST_SPN_MSG="\n${WHITE}${WORD} ${RED}does exist on spanish data base"
readonly GOOGLE_MSG="It seems that we can find ${WORD} using google script"

last_word_found=

if [ $# -ne 0 ]; then
  echo -e "${NO_ARGUMENTS_MSG}"
  return 1 
fi

process_english_word() {
  local word=$1
  printf ${AVAILABILITY_MSG}
  reproduce_english_audio_file_if_available ${word}
  display_english_translation ${word}
  last_word_found=${word}
  commit_vocabulary_changes ${word}
}

process_spanish_word() {
  local word=$1
  printf ${DOES_NOT_EXIST_SPN_MSG}
  spanish_word=${word}
  clean_spanish_file ${spanish_word}
  display_spanish_translation ${spanish_word}
  clean_english_word=$(echo "${INGLES}" | xargs)
  reproduce_english_audio_file_if_available ${clean_english_word}
  last_word_found=${clean_english_word}
  commit_vocabulary_changes ${clean_english_word}
}

process_unknown_word() {
  local word=$1
  printf ${GOOGLE_MSG}
  search_word_using_google_script ${word}
  reproduce_english_audio_file_if_available ${ingles} 
  display_option_to_add_new_word
  display_menu
  commit_vocabulary_changes ${word}
}

process_empty_word() {
  echo -e "${RED}Empty word"        
  reproduce_last_word_found_if_available ${last_word_found}
}

(
  # History setup local to this subshell session
  set -o history
  HISTFILE="$HOME/.lookup_history"
  HISTSIZE=1000
  touch "$HISTFILE"
  history -r "$HISTFILE"
  # Disable automatic recording of commands executed within this script
  set +o history

  while : ; do
    print_title $(basename $0)
    echo -e "${WHITE}"
    read -e -p "Type a word: " word
    
    if [ -n "$word" ]; then
      # Manually add only the typed word to history
      history -s "$word"
      history -w "$HISTFILE"
    fi
    
    if [ -z "${word}" ]; then
      process_empty_word
      continue
    fi
    
    if $(is_retrievable_english_word ${word}); then
      process_english_word "${word}"
    else
      printf ${DOES_NOT_EXIST_ENG_MSG}
      if $(is_retrievable_spanish_word ${word}); then
        process_spanish_word "${word}"
      else
        process_unknown_word "${word}"
      fi
    fi
  done
)
