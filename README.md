A virtual machine for the beginning programmer
===

This setup uses [Vagrant](http://www.vagrantup.com/) for local virtualisation 
and [SaltStack](http://docs.saltstack.com/) for automated provisioning.

## Usage

1. Install virtualbox and vagrant (and X11-server on OSX/Windows):
    - Ubuntu: 
        * `sudo apt-get install virtualbox`
        * vagrant > 1.5 - install deb manually: https://www.vagrantup.com/downloads.html
    - OSX: We recommend using [homebrew](http://brew.sh/) and [homebrew cask](http://caskroom.io/)
        * `brew cask install virtualbox`
        * `brew cask install vagrant`
    - Windows:
        * Download and install "VirtualBox platform package" for Window hosts: [Virtualbox Downloads](https://www.virtualbox.org/wiki/Downloads)
        * Download and install Vagrant for Windows: [Vagrant Downloads](https://www.vagrantup.com/downloads)
        * Reboot your machine.
        * Install Cygwin/X by following this procedure: [Setting Up Cygwin/X](http://x.cygwin.com/docs/ug/setup.html)
          - Important! In step 15 you must also choose the following packages:
            * git
            * make
            * openssh
            * git-completion
        * After installing Cygwin/X Windows users should use the program "XWin Server" for commands like git, make etc. 
2. Clone this repo from the command line (in a directory of your choice): 
   ```git clone https://github.com/akafred/devbox.git``` 
3. `cd devbox` into your cloned repo.
4. From the command line run: `make` to bootstrap the environment.

See [Makefile](Makefile) for more commands.

### Running development tools from inside the ls.test virtual machine

* Sublime: `make sublime`

###

Credits 

- Approach inspired by work done at Oslo Public Library (http://github.com/digibib)
- Tools inspired by the book "Programming for Beginners" by Kevin Partner.


