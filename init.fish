
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

# functions

function coverme 
  set -l user carolinem
  set -l project $argv[1]
  ssh $user@$user.dev.meetup.com -t "cd /usr/local/meetup/modules && /usr/local/meetup/tools/sbt ';coverage;$project/clean;$project/test;$project/coverageReport'" \
  ; and scp -r $user@$user.dev.meetup.com:/usr/local/meetup/modules/$project/target/scala-2.11/scoverage-report/ ~/projects/meetup-coverage \
  ; and open ~/projects/meetup-coverage/index.html
end

