# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.antigen/antigen.zsh

# Load the oh-my-zsh's library
antigen use oh-my-zsh

# Bundles from the default repo
antigen bundle bundler
antigen bundle colored-man-pages
antigen bundle command-not-found
antigen bundle deno
antigen bundle docker
antigen bundle docker-compose
antigen bundle git
antigen bundle heroku
antigen bundle kubectl
antigen bundle pip
antigen bundle python
antigen bundle rails
antigen bundle ruby
antigen bundle terraform
antigen bundle virtualenv
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme
antigen theme romkatv/powerlevel10k

antigen apply

# Setup `fzf` for zsh
source <(fzf --zsh)

# Setup `grc` for zsh
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
# export ZSH="/home/oxdfa/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(git)

# source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# Alias for PostgreSQL
# alias pg-run=
# alias pg-status=service postgresql status
# alias pg-start=service postgresql start
# alias pg-stop=service postgresql stop
# Alias for MYSQL
# alias mysql-run=mysql -u root -p
# Alias for ProtonVPN
# alias protonvpn-run=protonvpn c US-FREE#1
# Alias for ngrok
# alias ngrok="~/downloads/programs/ngrok"
# Alias for MailHog
# alias mailhog="~/go/bin/MailHog"
# Alias for microk8s K8s
# alias kubectl='microk8s kubectl'
# Alias for minikube K8s
# alias kubectl='minikube kubectl --'
# alias for talosconfig
# alias talos='export KUBECONFIG=~/.talos/configs/kubeconfig; export TALOSCONFIG=~/.talos/configs/talosconfig'
# Alias for `ls` -> `eza`
alias ls='eza --all --long --group --group-directories-first --icons --header --time-style long-iso'

# Ignore duplicate
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP

# Correction
setopt correct
setopt correctall

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Recognize .bashrc commands
[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

# Handle nvm installation
export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add Deno Path
export DENO_INSTALL="/home/oxdfa/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# Add Bun Path
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# Bun completions
[ -s "/home/oxdfa/.bun/_bun" ] && source "/home/oxdfa/.bun/_bun"

# Add Golang Path
export PATH=$PATH:/usr/local/go/bin

# Add Texlive Path
export PATH="$PATH:$HOME/texlive/2022/bin/x86_64-linux"
export MANPATH="$MANPATH:$HOME/texlive/2022/texmf-dist/doc/man"
export INFOPATH="$INFOPATH:$HOME/texlive/2022/texmf-dist/doc/info"

# Add Talos
export KUBECONFIG="$HOME/.talos/config/kubeconfig"
export TALOSCONFIG="$HOME/.talos/config/talosconfig"

# Add kubectl to Path
export PATH=$PATH:$HOME/.local/bin

# Change terminal title to reflect current directory
# PROMPT_COMMAND='echo -ne "\033]0;$(basename "$(pwd)")\007"'

# Terraform Auto-complete
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform

# Ruby
export PATH="$HOME/.rbenv/bin:$PATH"
FPATH=~/.rbenv/completions:"$FPATH"
eval "$(rbenv init -)"

# Atuin
eval "$(atuin init zsh)"
. "$HOME/.atuin/bin/env"

# Readme-Generator-for-Helm
export PATH="/home/oxdfa/Downloads/programs/readme-generator-for-helm/readme-generator-for-helm:$PATH"

# opencode
export PATH=/home/oxdfa/.opencode/bin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"
