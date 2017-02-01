#!/bin/sh



# cofig
INSTALL_INITD='true'
INSTALL_CAIROCON='true'
INSTALL_NETD='false'

REPOS_LIST="$PWD/repos.txt"
INSTALL_DIR="$HOME/cairo/"
BIN_FOLDER="$INSTALL_DIR/bin/"
WALK_FOLDER="$INSTALL_DIR/walkfiles/"

if [ -d "$INSTALL_DIR" ]; then
        rm -r "$INSTALL_DIR"
fi

if [ -e /etc/init.d/cairo-serverstart ]; then
        rm /etc/init.d/cairo-serverstart
fi

if [ -e /etc/network/if-up.d/cairo ]; then
        rm /etc/network/if-up.d/cairo
fi

if [ -e /etc/network/if-post-down.d/cairo ]; then
        rm /etc/network/if-post-down.d/cairo
fi