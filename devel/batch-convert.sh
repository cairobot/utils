#!/bin/bash



# author:   $TM_FULLNAME
# file:     $TM_FILENAME
# version:  0.0.0-r0
# since:    
# desc:



SCRIPT_DIR=~

# This function uses echo to print a message to sdterr
# and returns 1
function error() {
        echo "$@" 1>&2
        exit 1
}

# This function resolves a relative path into a absolute one.
# It depends on dirname and basename
function resolvePath() {
        (
                cd "$(dirname "$1")"
                local fil="$(echo "$PWD/$(basename "$1")")"
                if [[ "$fil" =~ ^.*/\.$ ]]; then
                        fil="$(echo "$fil" | rev | cut -c 2- | rev)"
                fi
                echo "$fil"
        )
}

# This function resolves symbolic links and returns the absolute
# path to the original file.
# It depends on readlink
function resolveFile() {
        local file="$1"
        while [[ -h "$file" ]]; do
                file="$(readlink "$file")"
        done
        echo "$file"
}

# Normalizes the given path and resolves all symbolic links.
# Depends on dirname, basename and readlink
function normalize() {
        if [[ $# -ne 1 ]]; then
                error "Error: no file specified"
        fi
        if [[ ! -e "$1" ]]; then
                error "Error: no such file"
        fi

        if [[ -h "$1" ]]; then
                resolveFile "$1"
                return 0
        else
                resolvePath "$1"
                return 0
        fi
}

# Initialises all default values
function init() {
        if [[ -f "$0" ]]; then
                SCRIPT_DIR="$(normalize "$(dirname "$0")")"
        fi
        if [[ "$SCRIPT_DIR" =~ ^.*/\.$ ]]; then
                SCRIPT_DIR="$(echo "$SCRIPT_DIR" | rev | cut -c 2- | rev)"
        fi
}

init
cd "$SCRIPT_DIR"

while getopts 'c:w:h' opt; do
        case $opt in
                c)
                        csvdir="$OPTARG"
                        ;;
                w)
                        waldir="$OPTARG"
                h)
                        echo "Program to batch-convert csvs to walkfiles"
                        echo "The walkfiles must be named after the following convention:"
                        echo "<ID>-<NAME>.CSV"
                        echo "options:"
                        echo " c ... the csv dir"
                        echo " w ... the walkfile destination dir"
                        echo " h ... this help dialog"
                        exit 0
        esac
done

for file in "$csvdir"/*.CSV; do
        name="$(basename "$file")"
        name="${name%.CSV}"
        arr=(${name//-/ })
        
        id_="${arr[0]}"
        name="${arr[1]}"

        echo "$name"
        cat "$file" | tr ';' ',' | ./csv2walk.sh -i "$id_" -n "$name" -V "0.1" -a deg -u prg | ./opt-walk.sh > "$waldir/$id_-$name.walk"
done