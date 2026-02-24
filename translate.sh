#!/bin/bash

# ─── Colors ─────────────────────────────────────────────
GREEN="\033[1;32m"
CYAN="\033[1;36m"
MAGENTA="\033[1;35m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# ─── Banner ─────────────────────────────────────────────
clear
echo "${CYAN}"
cat << "EOF"
╔══════════════════════════════════════╗
║   ▄▀█ █▄░█ █▀▀ █▀█ █▀█ █▀▄▀█         ║
║   █▀█ █░▀█ ██▄ █▀▀ █▀▄ █░▀░█         ║
║                                      ║
║   ░█▀▀▀█░█▀█▀█░█▀▀▀█░█▀▀▀█░          ║
║   FUTURISTIC TRANSLATOR TERMINAL     ║
╚══════════════════════════════════════╝
EOF
echo "${RESET}"

sleep 0.8

# ─── Main Loop ──────────────────────────────────────────
while true; do
  echo "${GREEN}▶ Select an option:${RESET}"
  echo "${CYAN}[1] Translate text"
  echo "[2] Exit${RESET}"
  echo

  read -p ">> " MENU_OPTION
  echo

  case $MENU_OPTION in
    1)
      echo "${MAGENTA}⌨ Enter text to translate:${RESET}"
      read -r INPUT_TEXT

      echo
      echo "${YELLOW}🌐 Target language code (en, es, fr, it, de, pt):${RESET}"
      read -r TARGET_LANG

      echo
      echo "${CYAN}⏳ Processing...${RESET}"
      sleep 0.5

      TRANSLATED_TEXT=$(trans -b :$TARGET_LANG "$INPUT_TEXT")

      echo
      echo "${GREEN}✔ Translation result:${RESET}"
      echo "${CYAN}$TRANSLATED_TEXT${RESET}"

      echo
      echo "${MAGENTA}🔊 Speak output? (y/n)${RESET}"
      read -r SPEAK_OPTION

      if [[ "$SPEAK_OPTION" =~ ^[Yy]$ ]]; then
        say "$TRANSLATED_TEXT"
      fi

      echo
      echo "${MAGENTA}💾 Export to file? (y/n)${RESET}"
      read -r SAVE_OPTION

      if [[ "$SAVE_OPTION" =~ ^[Yy]$ ]]; then
        TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
        FILE_NAME="translation_$TIMESTAMP.txt"

        {
          echo "INPUT:"
          echo "$INPUT_TEXT"
          echo
          echo "OUTPUT ($TARGET_LANG):"
          echo "$TRANSLATED_TEXT"
        } > "$FILE_NAME"

        echo "${GREEN}📄 Saved as ${FILE_NAME}${RESET}"
      fi

      echo
      echo "${CYAN}↩ Press ENTER to return to menu${RESET}"
      read
      clear
      ;;
    2)
      echo "${RED}⏻ Exiting system...${RESET}"
      sleep 0.6
      clear
      exit 0
      ;;
    *)
      echo "${RED}✖ Invalid option. Try again.${RESET}"
      sleep 1
      clear
      ;;
  esac
done