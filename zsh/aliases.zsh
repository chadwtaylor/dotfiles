alias zsha="nvim ~/.oh-my-zsh/custom/aliases.zsh"
alias zshc="nvim ~/.zshrc"
alias zshr=". ~/.zshrc"

alias resetcamera="sudo killall VDCAssistant"

alias ruby.install='rbenv install $(cat .ruby-version | sed -En "s/ruby-//p")'

alias arm="arch -arm64 zsh"
alias intel="arch -x86_64 zsh"

alias redis.flushall='redis-cli flushall'

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

alias hrc="heroku run console"

function heroku.restart() {
  heroku accounts:set linguabee 
  heroku restart -a api-linguabee 
  heroku restart -a hive-linguabee
  heroku restart -a linguabee
}

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
alias migrate.skep="be rake db:skep_migration_v1"
alias maskemail="be rake octoo:mask_emails"
alias maskemails="be rake octoo:mask_emails"
alias sidekiq="be sidekiq -e development -q default -q mailers -q broadcast"
alias sidekiq.broadcast="be sidekiq -e development -q broadcast -q notifiers -q default"

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

function oo2.db.dump_and_restore() {
  oo.db.dump; 
  oo2.db.restore;
}

function oo2.db.restore() {
  psql oo2_primary -c "drop schema public cascade; create schema public;";
  pg_restore --verbose --clean --no-acl --no-owner -h localhost -U chadwtaylor -d oo2_primary latest.dump;
  maskemail;
}

# -----------------------------------------------------------------------------
# OCTOO (v1 = oo1)
# -----------------------------------------------------------------------------

function oo1.api() {
  cd ~/Projects/octoo/oo1/api;
}

alias oo1.db.restore="pg_restore --verbose --clean --no-acl --no-owner -h localhost -U chadwtaylor -d oo1_primary latest.dump"

function oo1.db.dump_and_restore() {
  oo.db.dump; 
  oo1.db.restore;
}

# ------------------------------------------------------------------------------------------------------------
# JEKYLL
# ------------------------------------------------------------------------------------------------------------
alias nectar="cd ~/Projects/nectar"

function jbs() {
  be jekyll build;
  be jekyll serve --port=5000 --livereload;
}

function nectar.start() {
  nectar;
  jbs;
}

