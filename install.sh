#!/bin/bash

set -e

SHELL_START="# --- gnotes start ---"
SHELL_END="# --- gnotes end ---"
VIM_START='" --- gnotes start ---'
VIM_END='" --- gnotes end ---'
NOTES_DIR="$HOME/n"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

detect_shell_config() {
    case "$SHELL" in
        */zsh)  echo "$HOME/.zshrc" ;;
        */bash) echo "$HOME/.bashrc" ;;
        *)      echo "$HOME/.bashrc" ;;
    esac
}

check_already_installed() {
    local shell_config
    shell_config=$(detect_shell_config)
    if grep -qF "$SHELL_START" "$shell_config" 2>/dev/null || grep -qF "$VIM_START" "$HOME/.vimrc" 2>/dev/null; then
        echo "Gnotes is already installed. Run 'make uninstall' first."
        exit 1
    fi
}

prompt_repo_url() {
    echo "Enter your GitHub notes repo URL (e.g. https://github.com/user/notes):"
    read -r REPO_URL
    if [ -z "$REPO_URL" ]; then
        echo "No repo URL provided. Exiting."
        exit 1
    fi
}

setup_notes_dir() {
    if [ -d "$NOTES_DIR/.git" ]; then
        echo "~/n already exists as a git repo. Skipping clone."
    elif [ -d "$NOTES_DIR" ]; then
        echo "Error: ~/n already exists but is not a git repo. Move it and try again."
        exit 1
    else
        echo "Cloning notes repo to ~/n..."
        git clone "$REPO_URL" "$NOTES_DIR"
    fi
}

install_shell_snippet() {
    local shell_config snippet_file
    shell_config=$(detect_shell_config)

    case "$shell_config" in
        *zshrc)  snippet_file="$SCRIPT_DIR/snippets/zshrc.snippet" ;;
        *bashrc) snippet_file="$SCRIPT_DIR/snippets/bashrc.snippet" ;;
    esac

    {
        echo ""
        echo "$SHELL_START"
        cat "$snippet_file"
        echo "$SHELL_END"
    } >> "$shell_config"

    echo "Added shell snippet to $shell_config"
}

install_vimrc_snippet() {
    local vimrc="$HOME/.vimrc"
    touch "$vimrc"

    {
        echo ""
        echo "$VIM_START"
        cat "$SCRIPT_DIR/snippets/vimrc.snippet"
        echo "$VIM_END"
    } >> "$vimrc"

    echo "Added vimrc snippet to $vimrc"
}

check_already_installed
prompt_repo_url
setup_notes_dir
install_shell_snippet
install_vimrc_snippet

echo ""
echo "Done. Restart your shell or run: source $(detect_shell_config)"
