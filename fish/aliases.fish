alias fishe "nvim ~/.config/fish/aliases.fish"
alias fisha "nvim ~/.config/fish/aliases.fish"
alias fishc "nvim ~/.config/fish/config.fish"
alias fishr ". ~/.config/fish/config.fish"

alias resetcamera "sudo killall VDCAssistant"

alias pag 'ps aux | grep '

# alias flushdns 'dscacheutil -flushcache && sudo killall -HUP mDNSResponder'

# ------------------------------------------------------------------------------------------------
# Ruby-related Commands
# ------------------------------------------------------------------------------------------------
alias ruby.install 'rbenv install (cat .ruby-version | sed -En "s/ruby-//p")'

# ------------------------------------------------------------------------------------------------
# Rails-related Commands
# ------------------------------------------------------------------------------------------------

alias rc "bundle exec rails c"
alias seedbase "bundle exec rake db:seed:base"
alias redis 'redis-server /usr/local/etc/redis.conf'
alias redis.flushall 'redis-cli flushall'
alias sidekiq 'bundle exec sidekiq -e development -q default -q mailers -q broadcast'
alias be 'bundle exec'
alias rollback 'bundle exec rake db:rollback '
alias migrate 'bundle exec rake db:migrate '
alias jmigrate 'bundle exec rake journal:db:migrate '
alias maskemails 'bundle exec rake db:mask_emails'
alias maskemail 'bundle exec rake db:mask_emails'
alias rgm 'bundle exec rails g migration'
alias rgjm 'bundle exec rails g journal_migration'

# ------------------------------------------------------------------------------------------------------------
# PSQL
# ------------------------------------------------------------------------------------------------------------

alias oo1.db.drop 'psql oo1_primary -c "drop schema public cascade; create schema public;"'
alias oo1.db.drop.test 'psql oo1_primary_test -c "drop schema public cascade; create schema public;"'
alias oo1.db.pg_restore 'pg_restore --verbose --clean --no-acl --no-owner -h localhost -U chadwtaylor -d oo1_primary latest.dump'

alias oo2.db.drop 'psql oo2_primary -c "drop schema public cascade; create schema public;"'
alias oo2.db.drop.test 'psql oo2_primary_test -c "drop schema public cascade; create schema public;"'
alias oo2.db.pg_restore 'pg_restore --verbose --clean --no-acl --no-owner -h localhost -U chadwtaylor -d oo2_primary latest.dump'

function db.restart
  rm /usr/local/var/postgres/postmaster.pid
  rm /usr/local/var/postgresql@10/postmaster.pid
  brew services restart postgresql@10
end

# ------------------------------------------------------------------------------------------------------------
# OCTOO SHARED: same/shared tools between V1 and V2
# ------------------------------------------------------------------------------------------------------------

function oo.db.dump
  heroku accounts:set linguabee
  heroku pg:backups:capture -a api-linguabee
  curl -o latest.dump (heroku pg:backups:url -a api-linguabee)
end

function oo.set_heroku
  heroku accounts:set linguabee
end

# ------------------------------------------------------------------------------------------------------------
# OCTOO V1
# ------------------------------------------------------------------------------------------------------------

function oo1
  cd ~/Dropbox/web_projects/octoo/oo1
  oo.set_heroku
end

function oo1.webapp
  cd ~/Dropbox/web_projects/octoo/oo1/webapp
  oo.set_heroku
end

function oo1.webapp.start
  oo1.webapp
  bundle exec rails s -p 3000
end

function oo1.api
  cd ~/Dropbox/web_projects/octoo/oo1/api
  oo.set_heroku
end

function oo1.api.start
  oo1.api
  bundle exec rails s -p 3001
end

function oo1.hive
  cd ~/Dropbox/web_projects/octoo/oo1/hive
  oo.set_heroku
end

function oo1.hive.start
  oo1.hive
  bundle exec rails s -p 3002
end

function oo1.db.restore
  oo1.db.drop
  oo1.db.pg_restore
  be rake journal:db:migrate
  maskemail 
  migrate
  seedbase
end

function oo1.db.dump_and_restore 
  oo.db.dump
  oo1.db.restore
end

# function lb.test.reset
#   cd ~/Dropbox/web_projects/linguabee/api
#   heroku accounts:set linguabee
#   # chruby (head -1 .ruby-version)
#   psql linguabee_api_test -c "drop schema public cascade; create schema public;"
#   psql linguabee_journal_test -c "drop schema public cascade; create schema public;"
#   be rake db:migrate RAILS_ENV=test
#   be rake journal:db:migrate RAILS_ENV=test
#   be rake db:seed:base RAILS_ENV=test
# end

function oo1.test.reset
  oo1.api
  psql oo1_primary_test -c "drop schema public cascade; create schema public;"
  psql oo1_journal_test -c "drop schema public cascade; create schema public;"
  be rake db:migrate RAILS_ENV=test
  be rake journal:db:migrate RAILS_ENV=test
  be rake db:seed:base RAILS_ENV=test
end

# ------------------------------------------------------------------------------------------------------------
# OCTOO V2
# ------------------------------------------------------------------------------------------------------------

function npm.reinstall
  rm -rf node_modules
  rm package-lock.json
  npm install
end

function oo2
  cd ~/Dropbox/web_projects/octoo/oo2
end

function oo2.webapp
  cd ~/Dropbox/web_projects/octoo/oo2/webapp
  oo.set_heroku
end

function oo2.webapp.start
  cd ~/Dropbox/web_projects/octoo/oo2/webapp
  oo.set_heroku
  # npm run dev
  yarn dev
end

function oo2.webapp.prod
  cd ~/Dropbox/web_projects/octoo/oo2/webapp
  oo.set_heroku
  npm run build
  npm run start
end


function oo2.api
  cd ~/Dropbox/web_projects/octoo/oo2/api
  oo.set_heroku
end

function oo2.api.start
  cd ~/Dropbox/web_projects/octoo/oo2/api
  oo.set_heroku
  bundle exec rails s -p 4001
end

function oo2.db.restore
  psql oo2_primary -c "drop schema public cascade; create schema public;"
  oo2.db.pg_restore
  maskemail 
end

function oo2.db.dump_and_restore
  oo.db.dump
  oo2.db.restore
  echo 'Restored; however, you need to run `be rake db:skep_migration_v1`. Alternatively, you could use `oo2.db.dump_and_restore_and_migrate` in the future.'
end

function oo2.db.dump_and_restore_and_migrate
  oo2.db.dump_and_restore
  be rake db:skep_migration_v1
end


# ------------------------------------------------------------------------------------------------------------
# TIME IS MEAL
# ------------------------------------------------------------------------------------------------------------
function hungry.webapp.start
  cd ~/Dropbox/web_projects/timeismeal/hungry
  npm run dev
end


# ------------------------------------------------------------------------------------------------------------
# HUDDLO
# ------------------------------------------------------------------------------------------------------------
# alias hugapp 'cd ~/Dropbox/web_projects/huddlo/hug-webapp'
# alias hugapi 'cd ~/Dropbox/web_projects/huddlo/hug-api'

function hug.set_heroku
  heroku accounts:set huddlo
end

function hugapp 
  cd ~/Dropbox/web_projects/huddlo/hug-webapp
  hug.set_heroku
end

function hugapp.start
  hugapp
  npm run dev
end

function hugapi 
  cd ~/Dropbox/web_projects/huddlo/hug-api
  hug.set_heroku
end

function hugapi.start
  hugapi
  bundle exec rake hug:server NGROK=false PORT=9001 
end



# ------------------------------------------------------------------------------------------------------------
# JEKYLL
# ------------------------------------------------------------------------------------------------------------
alias nectar 'cd ~/Dropbox/web_projects/linguabee/nectar'

function jbs 
  jekyll build
  jekyll serve --port=5000 --livereload
end

function nectar.start
  cd ~/Dropbox/web_projects/linguabee/nectar
  jekyll build
  jekyll serve --port=5000 --livereload
end

# ------------------------------------------------------------------------------------------------------------
# HEROKU POSTGRES BACKUP AND DOWNLOAD
# ------------------------------------------------------------------------------------------------------------
# alias backup_api 'heroku pg:backups capture -a api-linguabee'
# alias backup_url 'heroku pg:backups -a api-linguabee public-url | cat' 
# alias backup_dl 'curl -o latest.dump'
# alias backup_help 'echo backup_api ... backup_url ... copy the url ... backup_dl paste url here with enclosed single quotations'

# SAMPLE USAGE
# ------------
# $ backup_api
# $ backup_url
# (copy the url from output)
# $ backup_dl '[paste url here]'

# ------------------------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------
# HEROKU STUFF
# ------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------
alias hlog 'heroku logs -t'
alias hrc 'heroku run console'

function heroku.restart
  heroku accounts:set linguabee
  heroku restart -a api-linguabee
  heroku restart -a hive-linguabee
  heroku restart -a linguabee
end

function heroku.restart.api
  heroku accounts:set linguabee
  heroku restart -a api-linguabee
end

function heroku.restart.hive
  heroku accounts:set linguabee
  heroku restart -a hive-linguabee
end

function heroku.restart.webapp
  heroku accounts:set linguabee
  heroku restart -a linguabee
end

function webapp.mt.on
  heroku maintenance:on -a linguabee
end

function webapp.mt.off
  heroku maintenance:off -a linguabee
end

function hive.mt.on
  heroku maintenance:on -a hive-linguabee
end

function hive.mt.off
  heroku maintenance:off -a hive-linguabee
end

function api.mt.on
  heroku maintenance:on -a api-linguabee
end

function api.mt.off
  heroku maintenance:off -a api-linguabee
end

function all.mt.on
  heroku maintenance:on -a linguabee
  heroku maintenance:on -a hive-linguabee
  heroku maintenance:on -a api-linguabee
end

function all.mt.off
  heroku maintenance:off -a linguabee
  heroku maintenance:off -a hive-linguabee
  heroku maintenance:off -a api-linguabee
end

# $ lb.update_production "http://long-assed-url-to-db"
# function lb.update_production
#   curl -o latest.dump $argv[1]
#   psql linguabee_api -c "drop schema public cascade; create schema public;"
#   pg_restore --verbose --clean --no-acl --no-owner -h localhost -U damon -d linguabee_api latest.dump
#   bundle exec rake db:mask_emails
# end

# ---------------------------------
# DAMON's UPDATE
# ---------------------------------
# function lb.update_db
#   cd ~/Documents/linguabee/linguabee-api
#   lb.chruby
# 
#   /usr/local/bin/heroku pg:backups:capture -a api-linguabee
#   curl -o latest.dump (/usr/local/bin/heroku pg:backups:url -a api-linguabee)
#   lb.update_db.local_copy
# end
# 
# function lb.update_db.journal
#   cd ~/Documents/linguabee/linguabee-api
#   lb.chruby
#   /usr/local/bin/heroku pg:backups:capture postgresql-shallow-35928 -a api-linguabee
#   curl -o latest_journal.dump (/usr/local/bin/heroku pg:backups:url -a api-linguabee)
#   lb.update_db.jounral.local_copy
# end
# 
# function lb.update_db.local_copy
#   psql linguabee_api -c "drop schema public cascade; create schema public;"
#   pg_restore --verbose --clean --no-acl --no-owner -h localhost -U damon -d linguabee_api latest.dump
#   bundle exec rake db:mask_emails
#   bundle exec rake db:seed:base
# end
# 
# function lb.update_db.journal.local_copy
#   psql linguabee_journal -c "drop schema public cascade; create schema public;"
#   pg_restore --verbose --clean --no-acl --no-owner -h localhost -U damon -d linguabee_journal latest_journal.dump
# end
# ---- RECEIVED JULY 11, 2020 BELOW
# function lb.update_db
#   lb.update_db.download_only
#   lb.update_db.local_copy
# end
# function lb.update_db.journal
#   lb.update_db.journal.download_only
#   lb.update_db.journal.local_copy
# end
# function lb.update_db.download_only
#   cdapi
#   /usr/local/bin/heroku pg:backups:capture -a api-linguabee
#   curl -o latest.dump (/usr/local/bin/heroku pg:backups:url -a api-linguabee)
# end
# function lb.update_db.journal.download_only
#   cdapi
#   /usr/local/bin/heroku pg:backups:capture postgresql-shallow-35928 -a api-linguabee
#   curl -o latest_journal.dump (/usr/local/bin/heroku pg:backups:url -a api-linguabee)
# end
# function lb.update_db.local_copy
#   cdapi
#   psql linguabee_api_development -c "drop schema public cascade; create schema public;"
#   pg_restore --verbose --clean --no-acl --no-owner -h localhost -U damon -d linguabee_api_development latest.dump
#   bundle exec rake "db:mask_emails[master]"
#   bundle exec rake db:seed:base
# end
# function lb.update_db.journal.local_copy
#   cdapi
#   psql linguabee_journal_development -c "drop schema public cascade; create schema public;"
#   pg_restore --verbose --clean --no-acl --no-owner -h localhost -U damon -d linguabee_journal_development latest_journal.dump
#   bundle exec rake "db:mask_emails[journal]"
# end
