#!/bin/sh



REPOS_LIST="$PWD/repos.txt"

INSTALL_DIR="$HOME/cairo/"
BIN_FOLDER="$INSTALL_DIR/bin/"
WALK_FOLDER="$INSTALL_DIR/walkfiles/"



if [ ! -d "$INSTALL_DIR" ]; then
        mkdir "$INSTALL_DIR"
fi
cd "$INSTALL_DIR"

while IFS= read -r line; do
        # echo "$line"
        export GIT_CURL_VERBOSE=1
        git clone "$line"
done <"$REPOS_LIST"

# create binary folder
mkdir "$BIN_FOLDER"
mkdir "$BIN_FOLDER/lib/"
mkdir "$WALK_FOLDER"

# install main-controller python source
cp -v main-controller/src/*.py "$BIN_FOLDER"

# compile uart library
(
        cd py-uart-lib
        ./configure && make clean && make deploy
        mv -v uart.tar.xz ../
)

# install uart library
tar -vxf uart.tar.xz
rm uart.tar.xz
mv -v uart.py "$BIN_FOLDER"
mv -v lib/* "$BIN_FOLDER/lib/"
rm -r lib/

# install init.d script (this starts the server on boot)
cat utils/spider/cairo-serverstart | sed 's:__INSTALL_DIR__:'"$INSTALL_DIR"':' > /etc/init.d/cairo-serverstart
chmod 755 /etc/init.d/cairo-serverstart
systemctl enable cairo-serverstart

# install cairocon
cp -v utils/spider/cairocon /usr/local/bin/
chmod 755 /usr/local/bin/cairocon

# install walkfiles
cp -v walkfiles/* "$WALK_FOLDER"

# setup path