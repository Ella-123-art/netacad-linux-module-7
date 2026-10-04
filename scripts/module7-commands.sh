#!/bin/bash
# Module 7 - Navigating the Filesystem
# NetAcad Linux course | Author: Emmanuella Odetsi Martey
#
# A replay of the commands practised in the lab, grouped by topic.
# Safe to run: every command is read-only (no files are created or deleted).
# Run it on a Linux machine or the NetAcad lab VM:  bash module7-commands.sh

section() { printf '\n=== %s ===\n' "$1"; }

section "1. Where am I? (pwd)"
pwd                      # print the current working directory
echo "$HOME"             # environment variables are case-sensitive: $HOME, not $Home

section "2. Tilde expansion (~)"
echo ~                   # current user's home directory
echo ~root               # root's home directory (/root)
echo ~nobody             # another user's home directory, as listed in /etc/passwd

section "3. Changing directory (cd) - absolute paths"
cd /usr/bin  && pwd
cd /usr      && pwd
cd /usr/share/doc && pwd

section "4. Changing directory (cd) - relative paths"
cd bash      && pwd      # relative to /usr/share/doc
cd ..        && pwd      # one level up (parent directory)
cd ~         && pwd      # back home
cd -                     # jump to the previous directory

section "5. Listing files (ls)"
ls                       # names only
ls -a                    # include hidden files (names beginning with .)
ls -l /etc/hosts         # long listing of one file
ls -lrt /etc/ssh         # long listing, reverse (-r) time (-t) order: oldest first
ls -R /etc/udev          # recursive listing of sub-directories
\ls                      # backslash bypasses the 'ls --color=auto' alias
type ls                  # shows that ls is aliased

section "6. File globbing (wildcards)"
ls -d /etc/s*            # * matches any number of characters
ls -d /etc/????          # ? matches exactly one character each (4-letter names)
ls -d /etc/[abcd]*       # [] matches one character from the set
cd ~ && ls -d [A-Z]*     # a range inside []

section "7. Permissions on directories"
ls -ld /root             # root's home is not readable by normal users
cd ~root 2>&1 | head -1  # expected: Permission denied
