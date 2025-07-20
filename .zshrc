# ╔═══════════════════════════════════════════════╗
# ║                                               ║
# ║     ███████╗███████╗██╗  ██╗██████╗  ██████╗  ║
# ║     ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝  ║
# ║       ███╔╝ ███████╗███████║██████╔╝██║       ║
# ║      ███╔╝  ╚════██║██╔══██║██╔══██╗██║       ║
# ║  ██╗███████╗███████║██║  ██║██║  ██║╚██████╗  ║
# ║  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ║
# ║                                               ║
# ╚═══════════════════════════════════════════════╝

# =================================================
# General Configs
# =================================================

# Keybindings
bindkey "^p" history-search-backward
bindkey "^n" history-search-forward

# History
HISTSIZE=5000
HISTFILE="$HOME/.zsh_history"
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling

# Case-insensitive matching
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"

# Enable filename colorizing
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"

# Force zsh not to show completion menu, use fzf-tab instead
zstyle ":completion:*" menu no

# Preview directory's content with cd
zstyle ":fzf-tab:complete:cd:*" fzf-preview 'eza -1a --color=always --icons=always $realpath'
zstyle ":fzf-tab:complete:__zoxide_z:*" fzf-preview 'eza -1a --color=always --icons=always $realpath'

# Smart preview - eza for directories, bat for files
zstyle ':fzf-tab:complete:*' fzf-preview '
if [[ -d $realpath ]]; then
  eza -1a --color=always --icons=always $realpath
elif [[ -f $realpath ]]; then
  bat --color=always --line-range=:500 $realpath
fi'

# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fz
zstyle ":fzf-tab:*" use-fzf-default-opts yes

# switch group using `<` and `>`
zstyle ":fzf-tab:*" switch-group "<" ">"

# =================================================
# Env Variables
# =================================================

# Add Homebrew to system PATH + env variables
eval "$(/opt/homebrew/bin/brew shellenv)"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Add ~/.local/bin to system PATH - shell can find and run installed executables without sudo
export PATH="$HOME/.local/bin:$PATH"

# Add Postgres to system PATH
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

# Use Catppuccin theme for fzf
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#313244,label:#CDD6F4"

# Use fd to generate input for fzf
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# =================================================
# Plugin Manager
# =================================================

# Set the directory we want to store zinit and plugins
export ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit"

# Download Zinit if not installed
if [ ! -d $ZINIT_HOME ]; then
  echo "Installing Zinit..."
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
elif [ ! -d $ZINIT_HOME/.git ]; then
  echo "Zinit directory exists but git repo is incomplete, re-cloning..."
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source and load zinit
source "${ZINIT_HOME}/zinit.zsh"

# =================================================
# Plugin Loading
# =================================================
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab

# Load completions
autoload -U compinit && compinit

# =================================================
# Personal Aliases & Functions
# =================================================

# Shorter clear & exit commands
alias c="clear"
alias e="exit"

# Confirm before overwriting and verbose output
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -iv"

# Grep with color
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

# Dev aliases
alias nv="nvim"
alias python="python3"
alias pip="pip3"

# Quick navigation
alias ..="cd .."

# Use bat for cat!
if command -v bat &> /dev/null; then
  alias cat="bat"
fi

# Use eza for ls!
if command -v eza &> /dev/null; then
  alias l="eza -1 --color=always --icons=always"
  alias la="eza -1a --color=always --icons=always"
  alias ls="eza --color=always --icons=always"
  alias lsa="eza -a --color=always --icons=always"
  alias ll="eza -l --color=always --icons=always --no-user --git-repos-no-status --time-style='long-iso'"
  alias lla="eza -la --color=always --icons=always --no-user --git-repos-no-status --time-style='long-iso'"
  alias lt="eza --tree --color=always --icons=always"
  alias lta="eza -a --tree --color=always --icons=always"
else
  alias ls="ls -h --color=auto"
  alias lsa="ls -ah --color=auto"
  alias ll="ls -lh --color=auto"
  alias lla="ls -lha --color=auto"
fi

# Use fd for find!
if command -v fd &> /dev/null; then
  alias find="fd"
fi

# Make dir then cd into it
md() {
  mkdir -p $1
  cd $1
}

# =================================================
# Suffix Aliases
# =================================================

# Open text files in nvim
alias -s txt="nvim"

# Open HTML files in Firefox
alias -s html="firefox"

# =================================================
# Initialize Shell Integrations and Tools
# =================================================

# mise-en-place - universal dev environment
eval "$(mise activate zsh)"

# fzf shell integrations - better find navigation
eval "$(fzf --zsh)"

# zoxide integration - better cd
eval "$(zoxide init --cmd cd zsh)"

# starship integration - better prompts
eval "$(starship init zsh)"

