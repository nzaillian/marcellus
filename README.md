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
specified command will run after the user is authenticated. SSH will also add an environment
variable named "SSH\_ORIGINAL\_COMMAND" containing the user's original command
to the environment in which the command (in the line of the authorized\_keys file) is
executed.

Marcellus writes to the ssh authorized\_keys file for the "git" user.
If you open it after adding some keys through Marcellus you'll find lines like

  command="/home/git/marcellus/bin/marcellus authenticate joesmith", [other options] ssh-rsa [user's public key]

This means that when user "joesmith" logs in the command "bin/marcellus" (relative to install root) is executed. As explained above, it has access to the original command issued to the ssh endpoint in the "SSH\_ORIGINAL\_COMMAND" environment variable, so it can choose whether to shell out and execute it with git shell (allow repo access) or ignore it (effectively deny repo access). How does it know what to do?

First, it parses out the repo path from the command issued by the user. It then 
checks the target repo for a special file called ".mc-access". This file (also
managed by Marcellus) contains a serialized list of the users who we can consider
to have granted access to the repo and their permissions ([:r], [:w] or [:r, :w]). If Marcellus sees the client user in that 
list and he has appropriate permissions, it will allow access (execute original command in git shell). 
If not, it will deny it. That's it.

### Library

The supplied runner script (bin/marcellus) is a thin wrapper around functionality defined
in the modules in the "lib" directory. If you'd like to peroform any of the actions
that you can through the CLI, refer to the contents of "bin/marcellus" to see how to
do the same with the library modules

### Configuration

You can find Marcellus' default path and shell options set in lib/marcellus/configuration.rb.You override Marcellus' defaults by dropping a file called ".marcellus-rc" in the "git" user's home directory. You can write a plain ruby tho this file (refer to lib/marcellus/configuration.rb for the available configuration options). For example:

    Marcellus::config.authorized_keys_path = "/home/git/.ssh/authorized_keys"
    Marcellus::config.repo_root = "/home/git/repositories"
