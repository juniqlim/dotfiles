export PYTHON_PATH=/usr/local/bin/python3

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export PATH="/Users/juniq/.cargo/bin:/Users/juniq/.jenv/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="/Users/juniq/.jenv/shims:$PYTHON_PATH:${PATH}"
export JENV_SHELL=zsh
export JENV_LOADED=1
unset JAVA_HOME
source '/opt/homebrew/Cellar/jenv/0.6.0/libexec/libexec/../completions/jenv.zsh'
jenv rehash 2>/dev/null
jenv refresh-plugins
jenv() {
  typeset command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  enable-plugin|rehash|shell|shell-options)
    eval `jenv "sh-$command" "$@"`;;
  *)
    command jenv "$command" "$@";;
  esac
}
eval "$(pyenv init -)"

# Added by Antigravity
export PATH="/Users/juniq/.antigravity/antigravity/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Claude Code alias
alias cl='claude'
alias cc="claude --dangerously-skip-permissions"
alias cx="codex --dangerously-bypass-approvals-and-sandbox"
alias ge="gemini -y"
alias aa='cd ~/ai-agent'
alias tk='cd ~/ai-agent/think'
alias jn='cd ~/j/note'
alias df='cd ~/j/dotfiles'
alias ji='cd ~/j/note/investment'
alias gt='cd ~/j/growterm'
alias tk='cd ~/j/think'
alias ccs="bun /Users/juniq/develop/code/juniqlim/claude-skin/src/index.tsx --effort low --append-system-prompt 'PC통신체로 짧게 답변' --dangerously-skip-permissions"
export NODE_OPTIONS='--no-deprecation'

# bun completions
[ -s "/Users/juniq/.bun/_bun" ] && source "/Users/juniq/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Helper functions
ccc() { cd ~/cc && cc; }
jicc() { cd ~/j/note/investment && cc; }
jncc() { cd ~/j/note && cc; }
aac() { cd ~/ai-agent && cc; }
aax() { cd ~/ai-agent && cx; }
jpcc() { cd ~/j/note/programming && cc; }

# Load secrets (not in public repo)
[[ -f ~/.secrets ]] && source ~/.secrets

alias cr='cc -r'

[[ -f "\/Users/juniq/.config/kaku/zsh/kaku.zsh" ]] && source "\/Users/juniq/.config/kaku/zsh/kaku.zsh" # Kaku Shell Integration
