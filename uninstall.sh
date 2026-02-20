#!/bin/bash

SHELL_START="# --- gnotes start ---"
SHELL_END="# --- gnotes end ---"
VIM_START='" --- gnotes start ---'
VIM_END='" --- gnotes end ---'
NOTES_DIR="$HOME/n"

detect_shell_config() {
    case "$SHELL" in
        */zsh)  echo "$HOME/.zshrc" ;;
        */bash) echo "$HOME/.bashrc" ;;
        *)      echo "$HOME/.bashrc" ;;
    esac
}

remove_block() {
    local file="$1"
    local start_marker="$2"
    local end_marker="$3"

    if ! grep -qF "$start_marker" "$file" 2>/dev/null; then
        echo "No gnotes block found in $file"
        return
    fi

    local tmpfile in_block=0
    tmpfile=$(mktemp)

    while IFS= read -r line; do
        if [[ "$line" == *"$start_marker"* ]]; then
            in_block=1
        fi
        if [ "$in_block" -eq 0 ]; then
            echo "$line"
        fi
        if [[ "$line" == *"$end_marker"* ]]; then
            in_block=0
        fi
    done < "$file" > "$tmpfile"

    mv "$tmpfile" "$file"
    echo "Removed gnotes block from $file"
}

remove_notes_dir() {
    if [ -d "$NOTES_DIR" ]; then
        echo "Remove ~/n? This will delete your local notes copy. [y/N]"
        read -r confirm
        if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
            rm -rf "$NOTES_DIR"
            echo "Removed ~/n"
        else
            echo "Kept ~/n"
        fi
    fi
}

shell_config=$(detect_shell_config)
remove_block "$shell_config" "$SHELL_START" "$SHELL_END"
remove_block "$HOME/.vimrc" "$VIM_START" "$VIM_END"
remove_notes_dir

echo "Gnotes uninstalled."
