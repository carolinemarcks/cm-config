
set PATH ~/projects/re-search $PATH

set -U fish_key_bindings fish_vi_key_bindings

function fish_mode_prompt
end

brew update
brew doctor

# aliases
alias devbox="ssh carolinem@carolinem.dev.meetup.com"
alias lb0="ssh 199.27.131.2 -p 6656"
alias livesync="~/projects/workstation-sync/sync.sh --live"
alias meetup="cd ~/projects/meetup"
alias dotfiles="vim ~/projects/cm-dotfiles/"

# functions
function dotfile
  vim ~/projects/cm-dotfiles/$argv[1]
end

function coverme 
  set -l user carolinem
  set -l project $argv[1]
  ssh $user@$user.dev.meetup.com -t "cd /usr/local/meetup/modules && /usr/local/meetup/tools/sbt ';coverage;$project/clean;$project/test;$project/coverageReport'" \
  ; and scp -r $user@$user.dev.meetup.com:/usr/local/meetup/modules/$project/target/scala-2.11/scoverage-report/ ~/projects/meetup-coverage \
  ; and open ~/projects/meetup-coverage/index.html
end

function fish_user_key_bindings
  bind -M insert -m default jj force-repaint
end

