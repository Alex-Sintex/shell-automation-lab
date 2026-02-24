#!/bin/bash

CONFIG_FILE="$HOME/.ollama_config"
TTS_VOICE=""  # Global variable for selected voice

# Function to save the default model to a configuration file
save_default_model() {
    echo "default_model=$1" >"$CONFIG_FILE"
}

# Function to load the default model from the configuration file
load_default_model() {
    if [ -f "$CONFIG_FILE" ]; then
        . "$CONFIG_FILE"
    else
        default_model=""
    fi
}

# Function to list available models with numbers
list_models() {
    echo "Available models:"
    models=$(ollama list | tail -n +2) # Skip the first line (header)

    if [ $? -ne 0 ]; then
        echo "Error: Failed to list models."
        return 1
    fi

    local i=1
    while IFS= read -r model; do
        model_name=$(echo "$model" | awk '{print $1}')
        echo "$i. $model_name"
        ((i++))
    done <<<"$models"
}

# Function to select TTS voice (English Default or Spanish Mónica)
select_voice() {
    echo "Choose voice for text-to-speech:"
    echo "1. English (Default)"
    echo "2. Spanish (Mónica)"
    read -rp "Enter 1 or 2: " voice_choice

    if [[ "$voice_choice" == "2" ]]; then
        TTS_VOICE="Mónica"
    else
        TTS_VOICE=""  # Default system voice
    fi
}

# Function to interact with ollama in a chat loop
chat_loop() {
    clear
    local model="$1"
    echo "-------------------------------------"
    echo "Starting chat with model: [$model]"
    echo "Type 'exit' to end the session."
    echo "-------------------------------------"

    while true; do
        read -rp "You >> " user_input

        if [ "$user_input" == "exit" ]; then
            echo "Exiting chat..."
            break
        fi

        local response
        response=$(ollama run "$model" "$user_input" 2>/dev/null)

        if [ -z "$response" ]; then
            echo "Error: No response from the model."
        else
            echo "AI >> $response"
            if command -v say &>/dev/null; then
                if [ -n "$TTS_VOICE" ]; then
                    say -v "$TTS_VOICE" "$response" --progress --rate=180
                else
                    say "$response" --progress --rate=180
                fi
            else
                echo "TTS not available. Displaying text only."
            fi
        fi
    done
}

# Main function
main() {
    if ! command -v ollama &>/dev/null; then
        echo "Error: ollama is not installed or not in PATH."
        exit 1
    fi

    # Load the default model
    load_default_model

    if [ -z "$default_model" ]; then
        echo "No default model set. Please select a model:"
        list_models
        read -rp "Enter the number of the model: >> " model_number

        models=$(ollama list | tail -n +2) # Skip the header
        model_name=$(echo "$models" | sed -n "${model_number}p" | awk '{print $1}')

        if [ -z "$model_name" ]; then
            echo "Invalid model number. Exiting."
            exit 1
        fi

        default_model="$model_name"
        save_default_model "$default_model"
        echo "Default model set to: $default_model"
    fi

    # Ask the user for voice preference
    select_voice

    while true; do
        clear
        echo "Menu:"
        echo "-------------------------"
        echo "1. Start chat"
        echo "2. Change model"
        echo "3. Change voice"
        echo "4. Exit"
        echo "-------------------------"
        read -rp "Choose an option: >> " choice

        case $choice in
        1)
            chat_loop "$default_model"
            ;;
        2)
            echo "Change model:"
            list_models
            read -rp "Enter the number of the new model: >> " new_model_number
            models=$(ollama list | tail -n +2)
            new_model_name=$(echo "$models" | sed -n "${new_model_number}p" | awk '{print $1}')

            if [ -z "$new_model_name" ]; then
                echo "Invalid model number. Try again."
                continue
            fi

            save_default_model "$new_model_name"
            default_model="$new_model_name"
            echo "Default model changed to: $default_model"
            ;;
        3)
            select_voice
            ;;
        4)
            echo "Exiting program. Goodbye!"
            clear
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
        esac
    done
}

# Run the main function
main