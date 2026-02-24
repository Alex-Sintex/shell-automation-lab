#!/usr/bin/env bash
# Command useful to play all tracks [m4a] format using “find”:
find . -type f -name "*.m4a" -exec sh -c '
    clear;
    afplay -v 2 -q 1 -d "$0" &  # Run afplay in the background
    # Store the PID of afplay
    pid=$!

    while true; do
        read -n 1 -s input      # Read a single key press (silent mode)
        case "$input" in
            p) kill -STOP $pid ;;  # Pause the song
            r) kill -CONT $pid ;;  # Resume the song
            q) kill $pid; break ;; # Quit the song and exit loop
        esac
    done
    # Wait for the song to finish
    wait $pid
' {} \;