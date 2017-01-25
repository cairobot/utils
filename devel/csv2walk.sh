#!/bin/bash



# author:   Manuel Federanko
# file:     csv2walk
# version:  0.0.0-r0
# since:    17-01-10
# desc:     see the help dialog



SCRIPT_DIR=~

# This function uses echo to print a message to sdterr
# and returns 1
error() {
        echo "$@" 1>&2
}

main() {
        local prg_id='0'
        local prg_version='0.0'
        local prg_name='testname'
        local prg_tick='100'
        local prg_use='prg'
        local prg_speed='1000'

        local load_step_dimension=''
        local load_last_time='0'
        local load_sep=','

        # i ... id
        # V ... version
        # n ... name
        # t ... tick
        # u ... use
        # s ... speed
        # a ... rad/deg/raw
        # h ... help
        while getopts 'i:V:n:t:u:s:a:h' opt; do
                case $opt in
                        i)
                                case "$OPTARG" in
                                        ''|*[!0-9]*) error "Error: expected a number" ;;
                                        *) prg_id="$OPTARG" ;;
                                esac
                        ;;
                        V)
                                prg_version="$OPTARG"
                        ;;
                        n)
                                prg_name="$OPTARG"
                        ;;
                        t)
                                case "$OPTARG" in
                                        ''|*[!0-9]*) error "Error: expected a number" ;;
                                        *) prg_tick="$OPTARG" ;;
                                esac
                        ;;
                        u)
                                prg_use="$OPTARG"
                        ;;
                        s)
                                case "$OPTARG" in
                                        ''|*[!0-9]*) error "Error: expected a number" ;;
                                        *) prg_speed="$OPTARG" ;;
                                esac
                        ;;
                        a)
                                if [ "$OPTARG" = 'raw' ]; then
                                        load_step_dimension=
                                elif [ "$OPTARG" = 'rad' ]; then
                                        load_step_dimension='r'
                                elif [ "$OPTARG" = 'deg' ]; then
                                        load_step_dimension='d'
                                else
                                        error "Error: expected one of the following values:"
                                        error "       raw, rad, deg"
                                fi
                        ;;
                        h)
                                echo "Used to translate csv files to walkfiles."
                                echo "Takes the csv from stdin and writes the"
                                echo "converted file to stdout."
                                echo "There are numerous flags available to"
                                echo "set file-options bevorehand:"
                                echo " i ... id"
                                echo " V ... version"
                                echo " n ... name"
                                echo " t ... tick"
                                echo " u ... use"
                                echo " s ... speed"
                                echo " a ... rad/deg/raw"
                                echo " h ... this help dialog"
                                exit 0
                        ;;
                esac
        done
        
        # create header of file
        echo '@/'
        echo 'version=0.0'
        echo '/@'
        echo ''
        echo '# auto-generated file header, adjust to your liking (can also be)'
        echo '# adjusted via the programs options'
        echo '[info]'
        echo '        Id='"$prg_id"
        echo '        Version='"$prg_version"
        echo '        Name='"$prg_name"
        echo '        Tick='"$prg_tick"
        echo '        Use='"$prg_use"
        echo '        Speed='"$prg_speed"
        echo '[end]'
        echo ''
        echo '# default setup instruction, change if the position of the legs'
        echo '# must be something else.'
        echo '[setup]'
        echo '        >d90..12,:0'
        echo '[end]'
        echo ''

        # begin with the actual program
        echo '# the program, every step is just copied into the file'
        echo '[prg]'

        IFS="$load_sep"
        while read -r instruction; do
                # remove the \r bc excel inserts it into the file,
                # we don't need it (it actually fucks up the output)
                instruction="$(echo "$instruction" | tr -d '\r')"
                local arr=( $instruction )
                local len=${#arr[@]}
                local i=1

                # echo "arr:${arr[@]}" 1>&2
                # echo "len:$len" 1>&2

                if [ $len -ne 13 ]; then
                        error "Error: suspicious number of instructions"
                        error "       there should only be 13 colums"
                        error "       1st col.: time"
                        error "       nth col.: motor positions"
                fi
                echo -n '        >'
                while [ $i -lt $len ]; do
                        echo -n ${arr[i]},
                        let i+=1
                done
                # echo 
                let timediff=${arr[0]}-$load_last_time
                load_last_time=${arr[0]}
                echo ':'"$timediff"


        done
        # end the prg instructions
        echo '[end]'
}

main "$@"