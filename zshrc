# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="cm-zsh-theme"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

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
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions cm-vi-mode)

source $ZSH/oh-my-zsh.sh

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

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

local -A config_array
config_array=(vimrc ~/.vimrc screenrc ~/.screenrc zshrc ~/.zshrc ztheme ~/.oh-my-zsh/custom/themes/cm-zsh-theme.zsh-theme cm-vi-mode/cm-vi-mode.plugin.zsh ~/.oh-my-zsh/custom/plugins/cm-vi-mode/cm-vi-mode.plugin.zsh)

config () {
	vim ~/projects/cm-config/$1
	update-configs
}

update-configs () {
	for k in "${(@k)config_array}"; do
		cp ~/projects/cm-config/$k $config_array[$k]
	done
}


config-diff () {
	if (( $# == 1 ))
	then 
		echo "diffing: $1"
		diff ~/projects/cm-config/$1 $config_array[$1]
	else
		echo "config-diff only accepts one arg"
	fi
}

config-diffs () {
	for k in "${(@k)config_array}"; do
		config-diff $k
	done
}

function custom_git_remote_status() {
	local remote ahead behind custom_git_remote_status 
	remote=${$(command git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
	if [[ -n ${remote} ]]; then
		ahead=$(command git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
		behind=$(command git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)

		if [[ $ahead -eq 0 ]] && [[ $behind -eq 0 ]]; then
			custom_git_remote_status="$ZSH_THEME_GIT_PROMPT_EQUAL_REMOTE"
		elif [[ $ahead -gt 0 ]] && [[ $behind -eq 0 ]]; then
			custom_git_remote_status="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE$((ahead))%{$reset_color%}"
		elif [[ $behind -gt 0 ]] && [[ $ahead -eq 0 ]]; then
			custom_git_remote_status="$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE$((behind))%{$reset_color%}"
		elif [[ $ahead -gt 0 ]] && [[ $behind -gt 0 ]]; then
			custom_git_remote_status="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE$((ahead))%{$reset_color%}$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE$((behind))%{$reset_color%}"
		fi

		echo $custom_git_remote_status
	fi
}
function custom_git_prompt_info() {
	local ref
	if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
		ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
			ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
		echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$(custom_git_remote_status)$ZSH_THEME_GIT_PROMPT_SUFFIX"
	fi
}

function laptopscreen () { screen -DR laptop }

function pull () { 
	if (( $# == 0 ))
	then
		git pull origin $(git rev-parse --abbrev-ref HEAD) 
	else
		echo "pull does not take arguments"
	fi
}
function fetch () { 
	if (( $# == 0 ))
	then
		git fetch origin $(git rev-parse --abbrev-ref HEAD) 
	else
		echo "fetch does not take arguments"
	fi
}
function branch () {
	if (( $# == 1 ))
	then
		BRANCH=$1
		git fetch origin $BRANCH 
		git rev-parse --verify $BRANCH 
		if (( $? == 0 ))
		then
			git checkout $BRANCH
		else
			BRANCH=${USER}_$1
			git fetch origin $BRANCH 
			git rev-parse --verify $BRANCH 
			if (( $? == 0 ))
			then
				git checkout $BRANCH
			else
				git checkout -b $BRANCH
			fi
		fi
	else
		git for-each-ref --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'
	fi
}
function master () {
	git checkout master
	git pull origin master
}
function squash () {
	if (( $# == 0 ))
	then
		git fetch origin master
		ORIG_BRANCH=$(git rev-parse --abbrev-ref HEAD)
		ORIG_HASH=$(git rev-parse HEAD)
		git checkout --detach
		git reset $(git merge-base origin/master $ORIG_BRANCH)
		git add -A
		git commit -m "SQUASHED: $ORIG_BRANCH $ORIG_HASH"
		git rebase origin/master
	else
		echo "squash does not take arguments"
	fi
}

function branch-clean () {
	git checkout master
	git branch | grep -v "master" | xargs git branch -d
}
function rebase () { 
	git fetch origin master 
	git rebase -i origin/master 
}

DISABLE_UNTRACKED_FILES_DIRTY="true"

# WORK
autoload -Uz compinit; compinit

autoload -Uz bashcompinit; bashcompinit

source ~/.bash_profile

source ~/.bashrc

function up-pay() { 
	echo "starting pay, directing output to pay.log..."
	echo "run tail-pay in another tab to see the output"
	echo "ctrl-c to stop pay"
	pay up &> ~/stripe/pay-server/pay.log 
}

function tail-pay { tail -F  ~/stripe/pay-server/pay.log }

function caroline-tail-pay { tail-pay | grep "CAROLINE" }

function error-tail-pay { tail-pay | grep -A 5 "An error occurred" }


function up-zoolander() {
	echo "starting zoolander sync to runway"
	sc-runway sync ~/stripe/zoolander:~/zoolander
}
function gen-api() { scripts/bin/remote-script scripts/dev/gen_openapi }
function gen-packages() { scripts/bin/remote-script scripts/packages/gen-packages.rb }
function gen-sorbet-shims() { scripts/bin/remote-script sorbet/shim_generation/missing_methods.rb }
function sync-gen() { scripts/packages/gen-packages }

function makegif() {
	# include trailing slash
	screenshot_dir=~/Desktop/
	latest_movie=$screenshot_dir`ls -tp "$screenshot_dir" | grep '.*\.mov' | head -n 1`
	gif_destination=`echo "$latest_movie" | sed 's/.mov/.gif/'`

	# brew install ffmpeg gifsicle
	ffmpeg -i "$latest_movie" -r 10 -f gif - | gifsicle > "$gif_destination"

	echo $gif_destination
	open -a "Google Chrome" "$gif_destination"
}

function await() {
	for var in "$@"
	do
		STATUS=$(pay status "$var" 2>&1)
		until (grep -q 'ready' <<< $STATUS)
		do
			sleep 5
			STATUS=$(pay status "$var" 2>&1)
		done	
	done

	osascript -e 'display notification "services ready" with title "Pay Services"'
}

function start() {
	STARTING_STATUS=$(pay status "$@" 2>&1)
	START=$(date +%s)
	pay start "$@"
	await "$@"
	END=$(date +%s)
	SECONDS=$(($END - $START))
	echo "start $@ : $SECONDS $STARTING_STATUS" >> ~/start-timings.txt
}

function qa-manage() {
	CONFIGURE_OUT=$(pay configure --show-db 2>&1)
	SLEEP=60
	if (grep -q 'Using QA DB' <<< $CONFIGURE_OUT)
	then
		TODAY=$(date "+%F")
		if (grep -q $TODAY <<< $CONFIGURE_OUT)
		then
			pay configure --db=qa
		else
			echo $CONFIGURE_OUT
			SLEEP=0
		fi
	else
		pay configure --db=qa
	fi	

	sleep $SLEEP
	start manage manage_ui	
}

GOPATH=~/go

# ARE YOU ON THE MASTER BRANCH?

# TODO FIND A PLACE TO PUT GIT ALIASES
# git config alias.current "rev-parse --abbrev-ref HEAD"

