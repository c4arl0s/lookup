#!/usr/bin/env bash

# new english version
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

COMODIN_DIRECTORY_PATH="$REPO_DIR/vocabulary"
ENGLISH_DIRECTORY_PATH="$REPO_DIR/vocabulary/english"
AUDIO_DIRECTORY_PATH="$REPO_DIR/vocabulary/audio-words"
SPANISH_DIRECTORY_PATH="$REPO_DIR/vocabulary/spanish"

TEMPORAL_DIRECTORY_PATH="$REPO_DIR/vocabulary"

. $REPO_DIR/helper-functions/clean_english_file.sh
. $REPO_DIR/helper-functions/colors.sh
. $REPO_DIR/helper-functions/clean_spanish_file.sh
. $REPO_DIR/helper-functions/delete_file_if_empty_or_blank.sh
. $REPO_DIR/helper-functions/delete_empty_files.sh

# trad-functions

# new english version
. $REPO_DIR/trad-functions/print_title.sh
. $REPO_DIR/trad-functions/is_retrievable_english_word.sh
. $REPO_DIR/trad-functions/is_retrievable_english_audio.sh
. $REPO_DIR/trad-functions/download_word_audio.sh
. $REPO_DIR/trad-functions/download_audio_from_google.sh
. $REPO_DIR/trad-functions/download_audio_from_wiktionary.sh
. $REPO_DIR/trad-functions/download_audio_from_google_tts.sh
. $REPO_DIR/trad-functions/convert_mp3_to_wav.sh
. $REPO_DIR/trad-functions/commit_vocabulary_changes.sh
. $REPO_DIR/trad-functions/is_retrievable_spanish_word.sh
. $REPO_DIR/trad-functions/display_spanish_translation.sh
. $REPO_DIR/trad-functions/format_english_file.sh
. $REPO_DIR/trad-functions/count_lines_spanish_file.sh
. $REPO_DIR/trad-functions/get_spanish_fields.sh
. $REPO_DIR/trad-functions/print_spanish_fields.sh
. $REPO_DIR/trad-functions/search_word_using_google_script.sh
. $REPO_DIR/trad-functions/display_option_to_add_new_word.sh
. $REPO_DIR/trad-functions/display_menu.sh
. $REPO_DIR/trad-functions/get_english_fields.sh
. $REPO_DIR/trad-functions/display_english_translation.sh
. $REPO_DIR/trad-functions/reproduce_audio.sh
. $REPO_DIR/trad-functions/reproduce_english_audio_file_if_available.sh
. $REPO_DIR/trad-functions/reproduce_last_word_found_if_available.sh
. $REPO_DIR/trad-functions/print_english_fields.sh
. $REPO_DIR/trad-functions/add_word.sh
. $REPO_DIR/trad-functions/transfer_spanish_translation.sh
. $REPO_DIR/trad-functions/transfer_english_translation.sh
. $REPO_DIR/trad-functions/get_translation.sh
. $REPO_DIR/trad-functions/print_added_translation.sh
. $REPO_DIR/trad-functions/create_spanish_file.sh
. $REPO_DIR/trad-functions/create_english_file.sh
. $REPO_DIR/trad-functions/get_number_of_lines_english_file.sh
. $REPO_DIR/trad-functions/is_available.sh

# add-functions

. $REPO_DIR/add-functions/print_header.sh
. $REPO_DIR/add-functions/read_inputs.sh
. $REPO_DIR/add-functions/print_inputs.sh
. $REPO_DIR/add-functions/create_english_file.sh
. $REPO_DIR/add-functions/create_spanish_file.sh
. $REPO_DIR/add-functions/save_english_translation.sh
. $REPO_DIR/add-functions/save_spanish_translation.sh
. $REPO_DIR/add-functions/save_verb.sh
