# Fresh Installation Notes

## Installing this dotfile project

Git-clone this project from your home directory (eg: `~/`) and run: 

`$ git clone git@github.com:chadwtaylor/dotfiles.git`

## ARM-based vs Intel-based

> When using `brew intsall` on ARM-based (M1) machine, installation directory will be `/opt/homebrew/...{app-name}` (eg: `/opt/homebrew/opt/postgresql@10`). For Intel-based machine, it will be `/usr/local/...{app-name}`. 

> To get the path for a specific app, run: `brew info {app-name}`


## Applications to install

### via app store
- Magnet (set up keyboard shortcut for 1/3 and 2/3 space)
- Slack
- Telegram

### via brew 
- git
  - `$ git config --global user.name "insert-username-here"`
  - `$ git config --global user.email "insert-email-here"`
  - `$ cd ~/.ssh && ssh-keygen` and follow output instructions as needed
  - `$ cat id_rsa.pub | pbcopy` copies the key into clipboard
  - Go to `github.com/settings/keys` and create `New SSH key` and do a paste
- rbenv
  - Add the following lines to ~/.zshrc 
    - `export PATH="$HOME/.rbenv/bin:$PATH"`
    - `eval "$(rbenv init - zsh)"`
    - If you need to begin installing ruby:
      - `rbenv install X.X.X`
      - if you're installing `2.6.3` specifically for legacy API, run the following command instead:
      - `$ RUBY_CFLAGS="-Wno-error=implicit-function-declaration" rbenv install 2.6.3`
- heroku cli (https://devcenter.heroku.com/articles/heroku-cli)
- nvm
  - `$ nvm install 16`
  - `$ nvm alias default 16`
  - Add the following to `.zshrc`: 
    ```
    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
    ```

- postgresql@10 (if using different version, use postgresql@13 for example)
  - To enable `psql`, add `export PATH="/opt/homebrew/opt/postgresql@10/bin:$PATH"` to ~/.zshrc
    - If you get `FATAL: database "your-username-here" does not exist`, run the command `$ createdb` and running `$ psql` should work
  - Troubleshooting: https://github.com/chadwtaylor/dotfiles/wiki/Troubleshooting
- redis 
  - `$ brew services start redis`

- nvim
- python

### via direct source
- Google Drive (https://www.google.com/drive/download/)
- VSCode
  - Enable Sync to load configurations: Preferences > Settings Sync (I believe sync happens with GitHub - can't remember)
  - For reference, refer to following files and edit as needed
    - `~/Library/Application Support/Code/User/settings.json`
    - `~/Library/Application Support/Code/User/snippets/...` <= for snippets such as `vue-script.json.code-snippets`
- Chrome
- Alfred (https://www.alfredapp.com/) 
  - Powerpack with license code
  - Set up advanced: Syncing: ~/iCloud Drive/Applications/Alfred
  - Disable macos spotlight keyboard shortcut
  - Setup Alfred Hotkey: Command-Space
  - Setup Features: Clipboard History Hotkey: Ctrl-Option-Command-H
- 1Password (https://1password.com/downloads/mac/)
- TablePlus
  - Preferences > Locations - link to ~/iCloud Drive/Applications/TablePlus/
- Insomnia Client
  - Go to Preferences > Data
    - Export data from old laptop into ~/iCloud Drive/Applications/TablePlus/ 
    - Import data into new laptop
  - Go to Preferences > Themes and choose `Gruvbox Dark`
- Sketch (then set up using subscription account)
- Wally (https://ergodox-ez.com/pages/wally)
- iStats Pro 
  - Refer to `Configurations` below to set menu bar date/time to an analog clock to use iStats data/time instead
- Convo

## Setting up ZSH and oh-my-zsh 

> Default shell for macos is `zsh`

- Installation instructions for `oh-my-zsh`: https://github.com/ohmyzsh/ohmyzsh/wiki
- After installing `oh-my-zsh`, perform the following commands:
  - `$ cd ~`
  - `$ mv .zshrc .zshrc.backup`
  - `$ git clone git@github.com:chadwtaylor/dotfiles.git`
  - `$ ln -s dotfiles/zsh/.zshrc .zshrc`
  - `$ ln -s dotfiles/zsh/aliases.zsh .oh-my-zsh/custom/aliases.zsh`

## Configurations

- Sys Pref > 
  - Security & Privacy > Use Apple Watch to unlock
  - Printers & Scanners > Add Brother Printer
  - Keyboard > Modifiers > Swap `Caps Lock` for `Esc`
  - Dock & Menu Bar > Clock (Menu Bar) > Time Options set to `Analog`
- `$ defaults write -g ApplePressAndHoldEnabled -bool false` to disable long-hold accent characters and use key-repeat instead
- Custom domain name
  - `$ nvim sudo /etc/hosts`
  - Add the following lines:
    ```
    127.0.0.1 linguabee.localhost
    127.0.0.1 app.localhost
    127.0.0.1 nectar.localhost
    ```

## Setting up development projects

### Octoo Webapp
- Ensure `export FONT_AWESOME_AUTH_TOKEN="insert-token-here"` is defined in `.zshrc`.
- Copy `.env` over from the old machine into the project root folder.
- `$ yarn install` to get started.
- `$ yarn dev` to boot up the server (or use alias like `$ oo2.webapp.start`)
> NOTE: I was on the `develop` branch when I ran into `js heap out of memory` error (common error for those on ARM-based environment) during the `$ yarn install` process. What fixed it for me was checking out the `main` branch, re-running the `yarn install` and it worked, then went back to the `develop` branch and did the `$ yarn install` again, it worked.
 

### Octoo API
> Before you do this, make sure you follow `rbenv` installation instructions above
> Also address items in this README: https://github.com/octoopi/api/blob/feature/v2/README.md
- `$ rbenv install X.X.X` (refer to `.ruby-version` for current version)
- Try `$ bundle install` (if no issue arises, you're in luck; otherwise, see possible issues/solutions below)
- Gem installation of `pg` may break, esp on M1 computers, try the following:
  - `$ gem install pg -- --with-pg-config=/opt/homebrew/opt/postgresql@10/bin/pg_config` (credit: https://gist.github.com/jonathandean/7449772)
- Gem installation of `idn-ruby` may break and if so, try the following: 
  - `gem install idn-ruby -v '0.1.4' -- --with-idn-dir=$(brew --prefix libidn)`
- When above issues clear, re-run `$ bundle install`
- Copy over the following files from the old machine: 
  - `application.yml`
  - `local_env.yml`
  - `master.key`
- Get latest db (make sure you're in legacy environment, run command: `oo1.api`)
  - `$ oo.db.dump`
  - `$ oo1.db.restore`
- Run in SQL terminal (eg: TablePlus): `drop database oo2_primary` and `create database oo2_primary with template oo1_primary`
- You need `oo2_journal` crap so create a `backup` (TablePlus > File > Backup) of `oo2_journal` from old laptop and then `restore` (TablePlus > File > Restore) into new laptop
- Run the migration (eg: `$ be rake db:skep_migration_v1`)
