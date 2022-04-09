# Auto-completion
# ---------------
source $XDG_CONFIG_HOME/fzf/completion.zsh

# Key bindings
# ------------
source $XDG_CONFIG_HOME/fzf/key-bindings.zsh
# fzf default behavior
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow -E ".git" -E "node_modules" -E ".steam" -E "Steam" . /etc /home/why'
#CTRL-T - Paste the selected files and directories onto the command-line
#CTRL-R - Paste the selected command from history onto the command-line
#ALT-C - cd into the selected directory

#### search in working dir
fw() {
    fd --type f --hidden --follow -E ".git" -E "node_modules" . \
        | fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'
}
fzf_theme=' --pointer="😺" --prompt="😺😺😺: "
            --color=fg:#f8f8f2,bg:#282a36,query:#ff0000,hl:#bd93f9 
            --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 
            --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 
            --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

#export FZF_DEFAULT_OPTS="$fzf_theme --height 60% --layout=reverse --preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -500'"
export FZF_DEFAULT_OPTS="$fzf_theme --height 40% --layout=reverse --border"



#==================  some functions ==============================

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
#_fzf_compgen_dir() {
  #fd --type d --hidden --follow --exclude ".git" . "$1"
#}
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" --full-path ~ "$1"
}

#### for ranger plugin fzm:
export FZF_FZM_OPTS="--reverse --height 75% --min-height 30 --cycle +m --ansi --bind=ctrl-o:accept,ctrl-t:toggle --select-1"
export FZF_DMARK_OPTS="--reverse --height 75% --min-height 30 --cycle -m --ansi --bind=ctrl-o:accept,ctrl-t:toggle"

### preview file 
ffp() {
    fzf --height 80% --preview 'bat --style=numbers --color=always --line-range :500 {}'
}

### show file info searched
function ff(){
    fzf --height 40% --layout reverse --info inline --border \
    --preview 'file {}' --preview-window up,1,border-horizontal \
    --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899'

}


#### navigation in $HOME
function j(){
        cd "$(fd --type d --hidden --follow --exclude ".git" . '/home/why' | fzf)"
}
### jump in ~ via ranger
function rj(){
        ranger $(fd --type d --hidden --follow --exclude ".git" . '/home/why' | fzf)
}

function sb(){
    bash "$(fd --type d --hidden --follow --exclude ".git" -e 'sh' | fzf)"
}

function completion_full_path() {
    fd --type d -H --absolute-path . '/home/why' | fzf
}

fzf-dirs-widget() {
  # eval cd $(dirs -v | fzf --height 40% --reverse | cut -b3-)
  local dir=$(dirs -v | fzf --height ${FZF_TMUX_HEIGHT:-40%} --reverse | cut -b3-)
  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi
  eval cd ${dir}
  local ret=$?
  unset dir # ensure this doesn't end up appearing in prompt expansion
  zle reset-prompt
  return $ret
}
zle -N fzf-dirs-widget

# Default ALT-X, For Mac OS: Option-X
if [[ `uname` == "Darwin" ]]; then
  bindkey '≈' fzf-dirs-widget
else
  bindkey '\ex' fzf-dirs-widget
fi
