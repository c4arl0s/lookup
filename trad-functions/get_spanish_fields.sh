#!/usr/bin/env bash

get_spanish_fields() {
  #WORD=$1
  #ROW=$2
  #ESPANOL=`cat ${SPANISH_DIRECTORY_PATH}/${WORD}.txt | tail -${ROW} | cut -f 1 -d ":"`
  #INGLES=`cat ${SPANISH_DIRECTORY_PATH}/${WORD}.txt | tail -${ROW} | cut -f 2 -d ":"`
  #EXTRA=`cat ${SPANISH_DIRECTORY_PATH}/${WORD}.txt | tail -${ROW} | cut -f 3 -d ":"`
  #P=`cat ${SPANISH_DIRECTORY_PATH}/${WORD}.txt | tail -${ROW} | cut -f 4 -d ":"`
  #PP=`cat ${SPANISH_DIRECTORY_PATH}/${WORD}.txt | tail -${ROW} | cut -f 5 -d ":"`
  #G=`cat ${SPANISH_DIRECTORY_PATH}/${WORD}.txt | tail -${ROW} | cut -f 6 -d ":"`
  #E=`cat ${SPANISH_DIRECTORY_PATH}/${WORD}.txt | tail -${ROW} | cut -f 7 -d ":"`  

  printf "\n${CYAN}Getting Spanish fields\n\n"
  WORD=$1
  ROW=$2
  FILE_NAME="${SPANISH_DIRECTORY_PATH}/${WORD}.txt"

  ESPANOL=`echo "$(<${FILE_NAME})" | tail -${ROW} | cut -f 1 -d ":"`
  INGLES=`echo "$(<${FILE_NAME})" | tail -${ROW} | cut -f 2 -d ":"`
  EXTRA=`echo "$(<${FILE_NAME})" | tail -${ROW} | cut -f 3 -d ":"`
  P=`echo "$(<${FILE_NAME})" | tail -${ROW} | cut -f 4 -d ":"`
  PP=`echo "$(<${FILE_NAME})" | tail -${ROW} | cut -f 5 -d ":"`
  G=`echo "$(<${FILE_NAME})" | tail -${ROW} | cut -f 6 -d ":"`
  E=`echo "$(<${FILE_NAME})" | tail -${ROW} | cut -f 7 -d ":"`
}
