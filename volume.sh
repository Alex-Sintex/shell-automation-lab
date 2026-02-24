#!/bin/bash
# Made by Kevin Al3xis
# 06/07/23
# Set custom volume level terminal

# Clear screen before processing info
clear

# Read input from user
echo "******************************************"
echo "Enter the desired volume level to be set: "
echo "******************************************"
read -p ">> " input_text

# Check if input_text is not a number
if ! [[ "$input_text" =~ ^[0-9]+$ ]]; then
  # Show error message
  echo "Error: Input is not a valid number!"
  # Exit the script
  exit
fi

# Use 'say' command to speak the text
say -v Paulina "Estableciendo volumen al $input_text por ciento" && sleep 3

# Set volume using osascript
osascript -e "set volume output volume $input_text"

# Clear screen after processing info
clear
