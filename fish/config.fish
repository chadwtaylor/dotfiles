source ~/.config/fish/aliases.fish

# source /usr/local/share/chruby/chruby.fish
# source /usr/local/share/chruby/auto.fish

# set -x PATH $PATH /bin
# set PATH /Users/chadwtaylor/.npm-global $PATH

# function nvm
#   bass source (brew --prefix nvm)/nvm.sh --no-use ';' nvm $argv
# end

# set -x NVM_DIR ~/.nvm
# nvm use default --silent

set -x FONT_AWESOME_AUTH_TOKEN E298C481-4FA0-41E2-8F2C-4EA418309665

set --universal fish_user_paths $fish_user_paths ~/.rbenv/shims
set -g fish_user_paths "/usr/local/opt/postgresql@10/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/openssl@1.1/bin" $fish_user_paths
