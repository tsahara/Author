#!/bin/sh

name=net.caddr.Author.Helper

sudo launchctl unload /Library/LaunchDaemons/$name.plist
sudo rm /Library/LaunchDaemons/$name.plist
sudo rm /Library/PrivilegedHelperTools/$name
