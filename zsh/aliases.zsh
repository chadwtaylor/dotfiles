alias zsha="nvim ~/.oh-my-zsh/custom/aliases.zsh"
alias zshc="nvim ~/.zshrc"
alias zshr=". ~/.zshrc"

alias resetcamera="sudo killall VDCAssistant"

alias ruby.install='rbenv install $(cat .ruby-version | sed -En "s/ruby-//p")'

alias arm="arch -arm64 zsh"
alias intel="arch -x86_64 zsh"

# -----------------------------------------------------------------------------
# POSTGRES
# -----------------------------------------------------------------------------
function db.restart() {
  rm /usr/local/var/postgres/postmaster.pid 
  rm /usr/local/var/postgresql@10/postmaster.pid
  brew services restart postgresql@10
}


# -----------------------------------------------------------------------------
# HEROKU
# -----------------------------------------------------------------------------

function oo.set_heroku() {
  # heroku accounts:set octoo
}

# -----------------------------------------------------------------------------
# RUBY ON RAILS
# -----------------------------------------------------------------------------
alias be="bundle exec"
alias rc="be rails c"
alias seedbase="be rake db:seed:base"
alias migrate="be rake db:migrate"
alias maskemail="be rake octoo:mask_emails"
alias maskemails="be rake octoo:mask_emails"

# -----------------------------------------------------------------------------
# NODE
# -----------------------------------------------------------------------------
function node.reinstall() {
  rm -rf node_modules;
  rm package-lock.json;
  rm yarn.lock;
  yarn install;
}

# -----------------------------------------------------------------------------
# OCTOO (general)
# -----------------------------------------------------------------------------

function oo.db.dump() {
  heroku pg:backups:capture -a api-linguabee;
  curl -o latest.dump $(heroku pg:backups:url -a api-linguabee);
}

# -----------------------------------------------------------------------------
# OCTOO (v2 = oo2)
# -----------------------------------------------------------------------------

function oo2.api() {
  cd ~/Projects/octoo/oo2/api;
  # oo.set_heroku
}

function oo2.api.start() {
  oo2.api;
  bundle exec rails s -p 4001;
}

function oo2.webapp() {
  cd ~/Projects/octoo/oo2/webapp;
  # oo.set_heroku
}

function oo2.webapp.start() {
  oo2.webapp;
  yarn dev;
}

# -----------------------------------------------------------------------------
# OCTOO (v1 = oo1)
# -----------------------------------------------------------------------------

function oo1.api() {
  cd ~/Projects/octoo/oo1/api;
}

alias oo1.db.restore="pg_restore --verbose --clean --no-acl --no-owner -h localhost -U chadwtaylor -d oo1_primary latest.dump"
