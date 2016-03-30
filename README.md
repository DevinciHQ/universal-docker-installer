# Using the Universal Docker Installer

## Installing dependencies
Before starting to use this universal docker installer, first install the dependencies in the following section.

## Usage
First things first, cd into the root directory of the universal docker installer.

For a full development environment installation, it is possible to execute the following single command:
```
ahoy setup
```
This will auto detect your operating system and proceed to full docker development environment setup.
Currently only Mac OSX, Debian based Linux distributions (Only Ubuntu is currently tested) and Arch Linux distribution are supported.

# Installer dependencies

## AHOY setup

### OSX
Using Homebrew:
```
brew tap devinci-code/tap
brew install ahoy
```

### Linux
Download and unzip the latest release and move the appropriate binary for your plaform into someplace in your $PATH and rename it `ahoy`

Example:
```
sudo wget -q https://github.com/devinci-code/ahoy/releases/download/1.1.0/ahoy-`uname -s`-amd64 -O /usr/local/bin/ahoy && sudo chown $USER /usr/local/bin/ahoy && chmod +x /usr/local/bin/ahoy
```

### More details on shell completion and usage
https://github.com/devinci-code/ahoy

# Troubleshooting

## List the available commands
If you want to list the available installer commands to execute a single command or for debugging reasons you can type:
```
ahoy
```

## Step by step setup
To show the help of the automated setup and know more details about the order of steps required for the development environment setup you can execute the following command:
```
ahoy help
```

## Consulting the script for the setup steps
The installer uses a main file ".ahoy.yml" which detects the operating system and invokes the appropriate commands for that specific operating system.

The specific operating system scripts are located at ".ahoy" directory.
As an example, to consult the commands required for installing docker on Ubuntu, check the file "debian.ahoy.yml" as Ubuntu is a Debian based Linux distribution (currently the commands are only tested on Ubuntu and not even Debian itself).

Mac OSX and Arch Linux are also supported.
