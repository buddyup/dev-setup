#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names
# Install Bash 4.
brew install bash
brew tap homebrew/versions
brew install bash-completion2
# We installed the new shell, now we have to activate it
echo "Adding the newly installed shell to the list of allowed shells"

# Prompts for password
if ! cat /etc/shells | grep "/usr/local/bin/bash"; then
    sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
    chsh -s /usr/local/bin/bash
fi
# Change to the new shell, prompts for password

# Install `wget` with IRI support.
brew install wget --with-iri

# Install RingoJS and Narwhal.
# Note that the order in which these are installed is important;
# see http://git.io/brew-narwhal-ringo.
# brew install ringojs
# brew install narwhal

# Install Python
brew install python
# brew install python3

# Install ruby-build and rbenv
# brew install ruby-build
# brew install rbenv
# LINE='eval "$(rbenv init -)"'
# grep -q "$LINE" ~/.extra || echo "$LINE" >> ~/.extra

# Install more recent versions of some OS X tools.
# brew install vim --override-system-vi
brew install homebrew/dupes/grep
# brew install homebrew/dupes/openssh
brew install homebrew/dupes/screen
# brew install homebrew/php/php55 --with-gmp

# Install font tools.
# brew tap bramstein/webfonttools
# brew install sfnt2woff
# brew install sfnt2woff-zopfli
# brew install woff2

# Install some CTF tools; see https://github.com/ctfs/write-ups.
# brew install aircrack-ng
# brew install bfg
# brew install binutils
# brew install binwalk
# brew install cifer
# brew install dex2jar
# brew install dns2tcp
# brew install fcrackzip
# brew install foremost
# brew install hashpump
# brew install hydra
# brew install john
# brew install knock
# brew install netpbm
# brew install nmap
# brew install pngcheck
# brew install socat
# brew install sqlmap
# brew install tcpflow
# brew install tcpreplay
# brew install tcptrace
# brew install ucspi-tcp # `tcpserver` etc.
# brew install xpdf
# brew install xz

# Install other useful binaries.
brew install ack
brew install dark-mode
#brew install exiv2
brew install git
brew install git-lfs
brew install git-flow
brew install git-extras
# brew install imagemagick --with-webp
brew install libsass
brew install lua
brew install lynx
brew install p7zip
brew install pigz
brew install pv
brew install rename
# brew install rhino
brew install speedtest_cli
# brew install ssh-copy-id
brew install tree
brew install webkit2png
brew install zopfli
brew install pkg-config libffi
brew install pandoc

# Lxml and Libxslt
brew install libxml2
brew install libxslt
brew link libxml2 --force
brew link libxslt --force

# Install Heroku
brew install heroku-toolbelt
heroku update

# Install Cask
brew install caskroom/cask/brew-cask

# Core casks
# brew cask install --appdir="/Applications" alfred
# brew cask install --appdir="~/Applications" iterm2
brew cask install --appdir="~/Applications" java
# brew cask install --appdir="~/Applications" xquartz

# Development tool casks
# brew cask install --appdir="/Applications" sublime-text3
# brew cask install --appdir="/Applications" atom
brew cask install --appdir="/Applications" virtualbox
# brew cask install --appdir="/Applications" vagrant
brew cask install --appdir="/Applications" heroku-toolbelt
heroku plugins:install https://github.com/heroku/heroku-accounts.git
# brew cask install --appdir="/Applications" macdown

# Misc casks
# brew cask install --appdir="/Applications" google-chrome
# brew cask install --appdir="/Applications" firefox
# brew cask install --appdir="/Applications" skype
brew cask install --appdir="/Applications" hipchat
brew cask install --appdir="/Applications" dropbox
# brew cask install --appdir="/Applications" evernote
#brew cask install --appdir="/Applications" gimp
#brew cask install --appdir="/Applications" inkscape

#Remove comment to install LaTeX distribution MacTeX
#brew cask install --appdir="/Applications" mactex

# Link cask apps to Alfred
# brew cask alfred link

# Install Docker, which requires virtualbox
brew install docker
brew install boot2docker
brew install postgresql94 memcached libmemcached redis
brew services start homebrew/versions/postgresql94
brew services start memcached
brew services start redis
mkdir -p /usr/local/var/postgres/{pg_tblspc,pg_twophase,pg_replslot,pg_stat_tmp,pg_stat,pg_snapshots,pg_logical}/
mkdir -p /usr/local/var/postgres/pg_logical/snapshots
mkdir -p /usr/local/var/postgres/pg_logical/mappings

# Make the database if it doesn't exist.
if [[ -z `psql -Atqc '\list buddyup' postgres` ]]; then createdb buddyup; fi


# Next?
# brew install Caskroom/cask/dockertoolbox
boot2docker config | sed "s/DiskSize = 20000/DiskSize = 30000/g" > ~/.boot2docker/profile

brew install unison
brew install fswatch
brew install Caskroom/cask/genymotion

# Set up dns
# sudo sh -c "echo 'nameserver `boot2docker ssh ifconfig | tr "\n" " " | pcregrep -o2 -iM "docker0(.*?)inet addr:(.*?) Bcast"`'> /etc/resolver/localdomain"
# sudo route -n add -net `boot2docker ssh ifconfig | tr "\n" " " | pcregrep -o2 -iM "docker0(.*?)inet addr:(.*?) Bcast" | pcregrep -o1 -i "(\d+?\.\d+?\.)"`0.0 `boot2docker ip`

sudo mkdir -p /var/lib/boot2docker
sudo touch /var/lib/boot2docker/profile

# Set up DNS
if ! cat /var/lib/boot2docker/profile | grep "bip"; then
    sudo sh -c "echo 'EXTRA_ARGS=\"--bip=172.17.42.1/24 --dns=172.17.42.1\"' >> /var/lib/boot2docker/profile"
fi
sudo sh -c "echo 'nameserver 172.17.42.1'> /etc/resolver/bu"
sudo route -n add -net 172.17.0.0 `boot2docker ip`
if ! cat /etc/hosts | grep "192.168.59.103 bu" > /dev/null ; then
    sudo sh -c "echo '192.168.59.103 api.bu' >> /etc/hosts"
    sudo sh -c "echo '127.0.0.1 bu app.bu marketing.bu gc.bu groundcontrol.bu m.bu dashboard.bu' >> /etc/hosts"
fi

if ! cat /etc/hosts | grep "dev.firebase.bu" > /dev/null ; then
    sudo sh -c "echo '192.168.59.103 dev.firebase.bu test.firebase.bu' >> /etc/hosts"
fi


# Install developer friendly quick look plugins; see https://github.com/sindresorhus/quick-look-plugins
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook suspicious-package

# Remove outdated versions from the cellar.
brew cleanup
