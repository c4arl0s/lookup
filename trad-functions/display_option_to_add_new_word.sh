#!/usr/bin/env bash

display_option_to_add_new_word()
{
  printf "\n${WHITE}${espanol} : ${ingles}"
  printf "\n${CYAN}Do you want to add this word?:${PINK} ${WORD} ?"
  printf "%s" "Type your choice [yes|edit|add3|↩(ignore)]: "; read decision
  echo -e "${GREEN}"
}
