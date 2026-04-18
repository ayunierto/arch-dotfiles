export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Custom configs
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.exports ] && source ~/.exports

# History
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export ANDROID_HOME=$HOME/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

export JAVA_HOME=/usr/lib/jvm/java-17-openjdk


# Perfiles de Poder Ryzen 7
alias set-power-perf='sudo ryzenadj --stapm-limit=28000 --fast-limit=28000 --slow-limit=28000 --vrm-current=60000 --tctl-temp=85'
alias set-power-extreme='sudo ryzenadj --stapm-limit=32000 --fast-limit=35000 --slow-limit=32000 --vrm-current=80000 --tctl-temp=90'
alias set-power-eco='sudo ryzenadj --stapm-limit=6000 --fast-limit=8000 --slow-limit=6000 --tctl-temp=95'
alias set-power-optimus-85='sudo ryzenadj --stapm-limit=32000 --fast-limit=34000 --slow-limit=32000 --tctl-temp=85 --vrm-current=70000 --apu-skin-temp=45'
