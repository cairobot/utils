#!/bin/sh


REPOS_LIST="$PWD/repos.txt"
INSTALL_DIR="$HOME/cairo/"
BIN_FOLDER="$INSTALL_DIR/bin/"
WALK_FOLDER="$INSTALL_DIR/walkfiles/"

if [ -d "$INSTALL_DIR" ]; then
        rm -r "$INSTALL_DIR"
fi

if [ -f /etc/systemd/system/cairo ]; then
        systemctl disable cairo
        rm /etc/systemd/system/cairo
fi

if [ -f /usr/local/bin/cairocon ]; then
        rm /usr/local/bin/cairocon
fi