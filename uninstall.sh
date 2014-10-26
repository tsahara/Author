#!/bin/sh

name=AuthorHelper

sudo launchctl unload /Library/LaunchDaemons/$name.plist
sudo rm /Library/LaunchDaemons/$name.plist
sudo rm /Library/PrivilegedHelperTools/$name
