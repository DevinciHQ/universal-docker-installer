#!/usr/bin/env bash

set -e

VERSION="0.0.1"

SHARE_FOLDER="~/docker-share"

MACHINE_NAME="default"

# Make a pseudo hashmap for legibility and because bash 3.x is the default on 
# OSX and it doesn't support bash hash arrays.
distro=0
release=1
codename=2
arch=3
OS=([$distro]="" [$release]="" [$codename]="" [$arch]="") 


show_help () {
  cat << EOF

UNIVERSAL DOCKER INSTALLER

version: $VERSION

Installs the docker suite of tools:
  - docker-engine (docker)
  - docker-machine
  - docker-compose

.. and dependencies
  - Virtualbox
  - docker-machine-nfs (speeds up docker-machine shares with nfs)

OSX
=====
  - Requires homebrew to be installed first.
  - Installs almost everything (including virtualbox) through homebrew
  - Installs docker-machine-nfs via curl


Linux (Defaults)
===============
  - Installs virtualbox via package manager when possible
  - Installs docker-engine via package manager when possible 
  - Installs docker-machine binary via curl. See https://docs.docker.com/machine/install-machine/
  - Installs docker-compose via curl.


Ubuntu
-------
  - Installs virtualbox (if not exists) through apt-get by adding virtualbox to apt sources.
  - Installs docker-engine through apt-get by adding docker to apt sources. 

ArchLinux
---------
  - [todo]

EOF
}


get_os() {

  if [ ! "$(which uname)" ]; then
    echo "WINDOWS NOT SUPPORTED YET"
    exit 1
  fi
  
  UNAME=$(uname)
  
  # We're on OSX
  if [ $UNAME == "Darwin" ]; then    
    OS[$distro]="OSX"
    OS[$release]="$(sw_vers -productVersion || false)"
    # Not worth mapping OSX codenames I think and there isn't an easy cli command
    # For codename on OSX.
    OS[$codename]=""
    OS[$arch]="$(uname -m)"
    OS[$kernal]="$(uname -r)"

  # UBUNTU and ARCH has lsb_release
  elif [ $(which lsb_release) ]; then
    OS[$distro]="$(lsb_release --id -s || false)"
    # On ARCH, this can be 'rolling' instead of a version number
    OS[$release]="$(lsb_release --release -s || false)"
    OS[$codename]="$(lsb_release --codename -s || false)"
    OS[$arch]="$(uname -m)"
    OS[$kernal]="$(uname -r)"
  
  else
    echo "This OS isn't supported yet"
    exit 1
  fi
}

get_rc_file() {
  if [ $SHELL == "/bin/zsh" ]; then
    RC_FILE="~/.zshrc"
  elif [ $SHELL == "/bin/bash" ]; then
    RC_FILE="~/bashrc"
  else
    "Error: Sorry, we don't support the $SHELL shell."
  fi
}

cmd() {
  printf "> $1 .. "
  local OUTPUT=`${@:2}`
  if [ -z $? ]; then
    echo "success"
  else
    echo "fail"
    exit 1
  fi
}


install_docker_engine() {

  # Use a specific shared folder instead of just /Users or /home so that nfs mounts don't conflict.
  # This is most important when running other vitualbox instances setup with nfs.
  if [ -d $SHARE_FOLDER ]; then 
    echo "Error: The share folder, '$SHARE_FOLDER' already exists. Please backup your data and remove the folder if you want to start over."
    exit 1
  else
    printf "> Creating the shared folder at $SHARE_FOLDER .. ";  mkdir $SHARE_FOLDER && echo "success" || ( echo "fail"; exit 1)
  fi

  if [ $OS{$distro} == "Darwin"]; then
    # Assume homebrew is a requirement for now
    if [ ! "$(which brew)" ]; then
      echo "Error: It looks like homebrew isn't installed. Please install that first."
      exit 1
    fi
    cmd "Updating Homebrew" brew update
    
    if [ -z "$(brew cask update)" ]; then
      echo "Error: It looks like homebrew cask isn't installed. As of Dec 2015, it should come with homebrew. Try 'brew update'"
    fi

    cmd "Installing the latest virtualbox" brew update
    cmd "Installing docker-engine" brew install docker
    cmd "Installing docker-machine" brew install docker-machine
    cmd "Installing docker-machine" brew install docker-machine
    cmd "Installing docker-machine-nfs" '
      curl -s https://raw.githubusercontent.com/adlogix/docker-machine-nfs/master/docker-machine-nfs.sh |
      sudo tee /usr/local/bin/docker-machine-nfs > /dev/null && sudo chmod +x /usr/local/bin/docker-machine-nfs'
    
    
    cmd "Creating a default docker-machine" docker-machine create --driver virtualbox $MACHINE_NAME
    cmd "Setting up the default docker-machine with NFS" docker-machine-nfs $MACHINE_NAME
    cmd "Starting docker-machine '$MACHINE_NAME'" docker-machine start $MACHINE_NAME
    cmd "Adding machine environment variables to $RC_FILE" 'docker-machine env $MACHINE_NAME | grep export >> $RC_FILE'
    cmd "Sourcing variables in '$RC_FILE'" source $RC_FILE

    cmd "Testing share folder" touch $SHARE_DIR
  fi





}

## MAIN ##

show_help
get_os
get_rc_file
cmd "this is a test" false
