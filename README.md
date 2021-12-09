# Fresh Installation Notes

## ARM-based vs Intel-based

> When using `brew intsall` on ARM-based (M1) machine, installation directory will be `/opt/homebrew/opt/{app-name}` (eg: `/opt/homebrew/opt/postgresql@10`). For Intel-based machine, it will be `/usr/local/{app-name}`. 

> To get the path for a specific app, run: `brew info {app-name}`


## Applications to install

### via brew 
- git
  - `git config --global user.name "insert-username-here"`
  - `git config --global user.email "insert-email-here"`
  - `cd ~/.ssh && ssh-keygen` and follow output instructions as needed
  - `cat id_rsa.pub | pbcopy` copies the key into clipboard
  - Go to `github.com/settings/keys` and create `New SSH key` and do a paste
- rbenv
  - Add the following lines to ~/.zshrc 
    - `export PATH="$HOME/.rbenv/bin:$PATH"`
    - `eval "$(rbenv init - zsh)"`
- heroku cli (https://devcenter.heroku.com/articles/heroku-cli)
- node 
  - then install yarn running this command: `npm install --global yarn`
  - ARM-related issue with `node-sass` in Octoo Webapp, need to use `node@14` until issue is resolved
    - `brew install node@14`
    - `brew link node@14`
    - `echo 'export PATH="/opt/homebrew/opt/node@14/bin:$PATH"' >> ~/.zshrc`
- postgresql@10 (if using different version, use postgresql@13 for example)
  - To enable `psql`, add `export PATH="/opt/homebrew/opt/postgresql@10/bin:$PATH"` to ~/.zshrc
    - If you get `FATAL: database "your-username-here" does not exist`, run the command `createdb` and running `psql` should work
- redis 
  - run command: `brew services start redis`
 
### via app store
- Magnet (set up keyboard shortcut for 1/3 and 2/3 space)
- Slack
- Authenticator 
- Final Cut Pro
- Xcode

### via direct source
- VSCode
- Chrome
- Alfred (https://www.alfredapp.com/) 
  - Powerpack with license code
  - Set up advanced: Syncing: ~/iCloud Drive/Applications/Alfred
  - Disable macos spotlight keyboard shortcut
  - Setup Alfred Hotkey: Command-Space
  - Setup Features: Clipboard History Hotkey: Ctrl-Option-Command-H
- 1Password (https://1password.com/downloads/mac/)
- Google Drive (https://www.google.com/drive/download/)
- Table Plus
  - Preferences > Locations - link to ~/iCloud Drive/Applications/TablePlus/
- Insomnia Client
  - Go to Preferences > Data
  - Export data from old laptop into ~/iCloud Drive/Applications/TablePlus/ 
  - Import data into new laptop
- Sketch (then set up using subscription account)
- Wally (https://ergodox-ez.com/pages/wally)
- iStats Pro 
- Convo

## Setting up ZSH and oh-my-zsh 

> Default shell for macos is `zsh`

- Installation instructions for `oh-my-zsh`: https://github.com/ohmyzsh/ohmyzsh/wiki
- Copy `.zshrc` to `~` (eg: ~/.zshrc)
- Copy `aliases.zsh` to `~/.oh-my-zsh/custom/` (eg: ~/.oh-my-zsh/custom/aliases.zsh)

## Configurations

- Sys Pref > 
  - Security & Privacy > Use Apple Watch to unlock
  - Printers & Scanners > Add Brother Printer

## Setting up development projects

### Octoo Webapp
- Ensure `export FONT_AWESOME_AUTH_TOKEN="insert-token-here"` is defined in `.zshrc`.
- For ARM-based machine, `node-sass` is not a supported package so ensure `node@14` is used for the time being.
- Vite doesn't play nicely with ARM-based environment so disable `nuxt-vite` from `nuxt.config.js` for the time being.
- Copy `.env` over from the old machine into the project root folder.
- Run: `yarn install` to get started.
- Run: `yarn dev` to boot up the server (or use alias like `oo2.webapp.start`)
  

### Octoo API
> Before you do this, make sure you follow `rbenv` installation instructions above
> Also address items in this README: https://github.com/octoopi/api/blob/feature/v2/README.md
- `rbenv install X.X.X` (refer to `.ruby-version` for current version)
- Try `bundle install` (if no issue arises, you're in luck; otherwise, see possible issues/solutions below)
- Gem installation of `pg` may break, esp on M1 computers, try the following:
  - Run this command: `gem install pg -- --with-pg-config=/opt/homebrew/opt/postgresql@10/bin/pg_config` (credit: https://gist.github.com/jonathandean/7449772)
- Gem installation of `idn-ruby` may break and if so, try the following: 
  - Run this command: `gem install idn-ruby -- --with-idn-dir=/opt/homebrew/Cellar/libidn/1.38`
- When above issues clear, re-run `bundle install`
- Copy over `application.yml`, `local_env.yml` and `master.key` over from the old machine
- Get latest db (make sure you're in legacy environment, run command: `oo1.api`)
  - run command: `oo.db.dump`
  - run command: `oo1.db.restore`
- Run `drop database oo2_primary` and `create database oo2_primary with template oo1_primary`
- You need `oo2_journal` crap so create a `backup` of `oo2_journal` from old laptop and then `restore` into new laptop
- Run the migration (eg: `be rake db:skep_migration_v1`)
