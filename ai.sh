#!/bin/bash

# Function to check if a voice exists
check_voice() {
    local voice="$1"
    if ! say -v "$voice" '' 2>/dev/null; then
        echo "The specified voice '$voice' does not exist. Exiting."
        exit 1
    fi
}

# Function to display a simple animation while waiting for user input
animate_waiting() {
    dots="...."
    start_time=$(date +%s)
    while [ $(( $(date +%s) - $start_time )) -lt 3 ]; do
        for ((i = 0; i < ${#dots}; i++)); do
            echo -en "AI thinking${dots:0:$i}   \r"
            sleep 0.5  # Sleep duration
        done
    done
}

while true; do
    # Initialize variables
    voice=""
    question=""

    # Check if voice argument is provided
    if [ "$#" -ge 1 ]; then
        if [ -n "$1" ]; then
            voice="$1"
            check_voice "$voice"  # Check if the voice exists
        else
            voice=""
        fi
        question="${2:-}"
    else
        # Ask the user to enter a voice
        echo "Enter a voice (e.g., Paulina for Spanish or just press Enter to use default):"
        read -p "> " user_voice
        if [ -n "$user_voice" ]; then
            voice="$user_voice"
            check_voice "$voice"  # Check if the voice exists
        else
            voice=""
        fi
    fi

    # If question is not provided as an argument, ask the user to enter it
    if [ -z "$question" ]; then
        echo "Enter a question:"
        read -p "> " question
    fi

    # Check for user interruption by pressing Enter
    if read -t 1 -s; then
        clear
        echo "Script interrupted by user."
        exit 0
    fi

    if [ -z "$question" ]; then
        echo "A question is required."
        exit 1
    fi

    clear
    animate_waiting
    response="$(aichat "$question")"

    # Clear the "AI thinking..." line and display the response
    echo -e "\033[1A\033[K"  # Move up one line and clear it
    echo -e "AI Response: \n$response"

    # Use say without the -v option if voice is not provided
    if [ -z "$voice" ]; then
        say "$response"
    else
        say -v "$voice" "$response"
    fi

    # Ask the user if they want to continue
    echo "Do you want to ask another question? (yes/no)"
    read -p "> " continue
    if [ "$continue" != "yes" ]; then
        clear
        break
    fi
done