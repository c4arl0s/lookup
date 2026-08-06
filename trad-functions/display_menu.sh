#!/usr/bin/env bash

display_menu()
{
  case ${decision} in 
  "yes")  echo -e "${GREEN}It will add word: ${ingles}"
          add_word "${espanol}" "${ingles}"
          LAST_WORD_FOUND=${ingles} ;;
  "edit") echo -e "${GREEN}Editing fields before adding..."
          printf "%s" "Type new English word [Current: ${ingles}]: "; read new_ingles
          [[ -n "$new_ingles" ]] && ingles="$new_ingles"
          
          printf "%s" "Type new Spanish translation [Current: ${espanol}]: "; read new_espanol
          [[ -n "$new_espanol" ]] && espanol="$new_espanol"
          
          add_word "${espanol}" "${ingles}"
          LAST_WORD_FOUND=${ingles} ;;
  "no")   echo -e "${RED}You cancelled" ;;
  "add3") add3 ;; 
  *) 	    echo -e "${CYAN}You did type enter";;
  esac
}
