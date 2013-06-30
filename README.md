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
Marcellus is really just a collection of simple utilities.

Marcellus relies on openSSH's "forced command" feature.
If you prefix "command=&lt;command&gt;" to any of the lines containing public keys in 
the "authorized\_keys" file sshd is reading from to authenticate the "git" user, the 
specified command will run after the user is authenticated. SSH will also add an environment
variable named "SSH\_ORIGINAL\_COMMAND" containing the user's original command
to the environment in which the command (in the line of the authorized\_keys file) is
executed.

Marcellus writes to the ssh authorized\_keys file for the "git" user.
If you open it after adding some keys through Marcellus you'll find lines like

  command="/home/git/marcellus/bin/marcellus authenticate joesmith", [other options] ssh-rsa [user's public key]

This means that when user "joesmith" logs in the command "bin/marcellus" (relative to install root) is executed. As explained above, it has access to the original command issues to the ssh endpoint in the "SSH\_ORIGINAL\_COMMAND" environment variable, so it can choose whether to shell out and execute it (allow repo access) or ignore it (effectively deny repo access). How does it know what to do?

First, it parses out the repo path from the command issued by the user. It then 
checks the target repo for a special file called ".mc-access". This file (also
managed by Marcellus) contains a serialized list of the users who we can consider
to have granted access to the repo. If Marcellus sees the client user in that 
list, it will allow access (shelling out and executing the command). 
If not, it will deny it. That's it.