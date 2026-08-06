#!/usr/bin/env bash

display_menu()
{
  case ${decision} in 
  "yes")  echo -e "${GREEN}It will add word: ${ingles}"
          if add_word "${espanol}" "${ingles}"; then
            last_word_found="${ingles}"
            reproduce_english_audio_file_if_available "${ingles}"
          fi ;;
  "edit") echo -e "${GREEN}Editing fields before adding..."
          printf "%s" "Type new English word [Current: ${ingles}]: "; read new_ingles
          [[ -n "$new_ingles" ]] && ingles="$new_ingles"
          
          printf "%s" "Type new Spanish translation [Current: ${espanol}]: "; read new_espanol
          [[ -n "$new_espanol" ]] && espanol="$new_espanol"
          
          if add_word "${espanol}" "${ingles}"; then
            last_word_found="${ingles}"
            reproduce_english_audio_file_if_available "${ingles}"
          fi ;;
  "no")   echo -e "${RED}You cancelled" ;;
  "add3") add3 ;; 
  *) 	    echo -e "${CYAN}You did type enter";;
  esac
}
