#!/bin/bash



# author:   Manuel Federanko
# file:     opt-walk
# version:  0.0.0-r0
# since:    17-01-10
# desc:     see the help dialog



SCRIPT_DIR=~
SED_REGEX='^([^>])*>(((r|d)?[0-9]{1,},)*):([0-9]{1,}).*$'
SED_EXT_FLAG=r

# This function uses echo to print a message to sdterr
# and returns 1
error() {
        echo "$@" 1>&2
}

init() {
        case "$(uname)" in
                Linux)
                        SED_EXT_FLAG=r
                ;;
                Darwin)
                        SED_EXT_FLAG=E
                ;;
                *)
                        SED_EXT_FLAG=r
                ;;

        esac
}

main() {
        local flag=0
        local stp_str=
        local lstp_str=
        local delay=0
        local ldelay=0
        local insert='        '

        init

        while read -r line; do
                case "$line" in
                        *'[prg]'*)
                                flag=1
                                echo "$line"
                        ;;
                        *'[end]'*)
                                if [ $flag -eq 1 ]; then
                                        flag=0
                                        let ldelay=ldelay+delay
                                        echo "$insert>$lstp_str:$ldelay"
                                fi
                                echo "$line"
                        ;;
                        *)
                                [ $flag -eq 0 ] && echo "$line"
                        ;;
                esac

                if [ $flag -eq 1 ]; then
                        stp_str="$(echo "$line" | sed -$SED_EXT_FLAG -n 's/'"$SED_REGEX"'/\2/p')"
                        delay="$(echo "$line" | sed -$SED_EXT_FLAG -n 's/'"$SED_REGEX"'/\5/p')"

                        if [ ! "$stp_str" = "$lstp_str" ]; then
                                let ldelay=ldelay+delay
                                if [ ! -z "$lstp_str" ]; then
                                        echo "$insert>$lstp_str:$ldelay"
                                fi
                                ldelay=0
                        else
                                let ldelay=ldelay+delay
                        fi
                        lstp_str="$stp_str"
                fi
        done
}

main "$@"