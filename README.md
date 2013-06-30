# Marcellus

A simple gatekeeper for Git over SSH

### What it does

Marcellus provides functionality similar to [gitolite](https://github.com/sitaramc/gitolite).
You create a "git" user on your host machine and install Marcellus. You can then enforce 
per-repo access policies for different clients based on their public keys 
(with all clients pushing to "git@yourhostname:repo-name.git"). You can 
manage users via a command line utility or through a Ruby interface.

### How it does it

One of my motivations for creating this tool was the difficulty I had hacking
gitolite. I've tried to keep the operation of this tool easy to understand. 
Marcellus is really just a collection of simple utilities. I strongly
encourage you to read all of the implementation outline below if you plan
on using Marcellus.

Marcellus is built atop openSSH's "forced command" feature.
If you prefix "command=&lt;command&gt;" to any of the lines containing public keys in 
the "authorized\_keys" file sshd reads from to authenticate the "git" user, the 
specified command will run after the user is authenticated. SSH will also add the environment
variable "SSH\_ORIGINAL\_COMMAND", which contains the user's original command,
to the environment in which the forced command is executed.

Marcellus writes to the ssh authorized\_keys file for the "git" user.
If you open it after adding some keys through Marcellus you'll find lines like

    command="/home/git/marcellus/bin/marcellus authenticate joesmith", [other options] ssh-rsa [user's public key]

This means that when user "joesmith" logs in the command "bin/marcellus" (relative to install root) is executed. As explained above, it has access to the original command issued to the ssh endpoint in the "SSH\_ORIGINAL\_COMMAND" environment variable, so it can choose whether to shell out and execute it with git shell (allow repo access) or ignore it (effectively deny repo access). How does it know what to do?

First, it parses out the repo path from the command issued by the user. It then 
checks the target repo for a special file called ".mc-access". This file (also
managed by Marcellus) contains a serialized list of the users who we can consider
to have access to the repo and their respective repo permissions ([:r], [:w] or [:r, :w]). If Marcellus sees the client user in that 
list and he has appropriate permissions, it will allow access (execute original command in git shell). 
If not, it will deny it. That's it.

### Library

The supplied runner script (bin/marcellus) is a thin wrapper around functionality defined
in the modules in the "lib" directory. If you'd like to peroform any of the actions
that you can through the CLI, you can do so relatively easily by requiring
"marcellus" in your Ruby applications. Refer to the contents of "bin/marcellus" to see how to
do get the same behavior packaged in the CLI through the library.

### Configuration

You can find Marcellus' default path and shell options set in lib/marcellus/configuration.rb.You override Marcellus' defaults by dropping a file called ".marcellus-rc" in the "git" user's home directory. You can write a plain Ruby to this file (refer to lib/marcellus/configuration.rb for the available configuration options). For example:

    Marcellus::config.authorized_keys_path = "/home/git/.ssh/authorized_keys"
    Marcellus::config.repo_root = "/home/git/repositories"

### Installation

create a "git" user on your machine

...on linux

    sudo useradd git
    sudo passwd git # (optional)

login as git user (either by ssh'ing to "git@localhost" or runining "su git" if "su" is enabled).

Install Ruby if not present (any version >= 1.9)

    sudo apt-get install ruby # (or install via RVM)

Clone this repository

    git clone https://github.com/nzaillian/marcellus

cd into it

    cd marcellus

build the gem

    gem build marcellus.gemspec

Install the gem from the current directory (by default "gem install" will first look for a ".gem" directory in the working directory before checking remotes).

    gem install marcellus

You should now have the "marcellus" binary on the current (git) user's $PATH

create a "~/.marcellus-rc" file and set up repository/user storage path locations as described in the "configuration" section above.

You should now be able to run the marcellus commands and set access rules (run "marcellus --help" to list all commands) on repositories in the "repo_root" specified in your configuration.

### Why no gem on RubyGems.org?

This project has not been very comprehensively battle-tested yet and putting it up on RubyGems.org for anybody to "gem install marcellus" would imply that it had. I'd rather 
force people to go through the more involved build/install process above and have 
a better understanding of what the application is actually doing while it's still in very early development.

### Why the name "marcellus"?

Marcellus' namesake is one of the 3 named castle guards in Shakespeare's "Hamlet"