#!/usr/bin/env bash

set -e

VERSION="0.0.1"

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


install_docker_engine() {

  if [ $OS{$distro} == "Darwin"]; then
    # Assume homebrew is a requirement for now
    


  fi





}

## MAIN ##

show_help
get_os
