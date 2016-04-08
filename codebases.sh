#!/usr/bin/env bash

# Wire up profile (revised, saner way to do it.)
cd ~
if [ -s .bash_profile.bak ]; then
    rm .bash_profile
    mv .bash_profile.bak .bash_profile
fi
if [ -s .gitconfig.bak ]; then
    rm .gitconfig
    mv .gitconfig.bak .gitconfig
fi
rm .bash_profile_buddyup
ln -s bootstrap/.bash_profile .bash_profile_buddyup

if ! cat .bash_profile | grep "bash_profile_buddyup"; then
    printf "\n# Added by BuddyUp Dev Setup\nsource .bash_profile_buddyup" >> .bash_profile
fi

if ! cat .gitconfig | grep "bootstrap/.gitconfig"; then
    printf "\n# Added by BuddyUp Dev Setup\n[include]\n\tpath = bootstrap/.gitconfig\n" >> .gitconfig
fi


# Set up dewey and polytester
pip install --upgrade pip
pip install polytester --upgrade
pip install git+https://git@github.com/buddyup/dewey.git#egg=dewey --upgrade

# Clone down the codebases
mkdir -p ~/buddyup
cd ~/buddyup
git clone git@github.com:buddyup/core.git

cd ~/buddyup
git clone git@github.com:buddyup/oliver.git
cd oliver
npm install -g ios-deploy webpack --unsafe-perm=true
npm install
ionic platform remove ios
ionic platform add ios
ionic platform remove android
ionic platform add android
