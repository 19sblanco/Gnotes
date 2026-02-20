# Gnotes

Keep your notes in plain text files with vim, automatically synced to GitHub.

## How it works

- Notes live in `~/n/` — a git repo connected to GitHub
- Every `:w` in vim auto-commits and pushes your changes
- Every time you open vim or a new shell, it pulls the latest changes
- Works from any machine

## Requirements

- vim
- git
- A GitHub repo to store your notes (can be private)

## Install

```bash
git clone https://github.com/your-username/gnotes
cd gnotes
make install
```

You'll be prompted for your GitHub notes repo URL. The script will clone it to `~/n/` and patch your `.vimrc` and shell config.

Restart your shell (or `source ~/.zshrc` / `source ~/.bashrc`) when done.

## Uninstall

```bash
make uninstall
```

Removes the snippets from your `.vimrc` and shell config. Optionally deletes `~/n/`.

## Usage

Open any file in `~/n/` with vim and just write. Saving syncs automatically.

```bash
vim ~/n/ideas.md
vim ~/n/work.md
```
