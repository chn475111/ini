#!/bin/sh

# author lijk@.infosec.com.cn
# date 2016-8-16 15:16:36

function _ini_usage()
{
    echo "Usage: $0 get filename section key
or
Usage: $0 set filename section key value"
    return 1
}

function _ini_get()
{
    local file=$1
    local sec=$2
    local key=$3

    if [ $# != 3 ]
        then
        _ini_usage $@
        return $?
    fi

    awk -F "[=;#]+" '/^\[[ \t]*'$sec'[ \t]*\]/{a=1}a==1&&$1~/^[ \t]*'$key'[ \t]*/{gsub(/[ \t]+/,"",$0);print $2;exit}' $file
    return $?
}

function _ini_set()
{
    local file=$1
    local sec=$2
    local key=$3
    local val=$4

    if [ $# != 4 ]
        then
        _ini_usage $@
        return $?
    fi

    sed -i "/^\[[ \t]*$sec[ \t]*\]/,/^\[/s/^[ \t]*\($key[ \t]*=[ \t]*\)[^ \t;#]*/\1$val/" $file
    return $?
}

function ini()
{
    local CMD=${1:-help}
    shift
    case ${CMD} in
        get)
            _ini_get $@
            ;;
        set)
            _ini_set $@
            ;;
        help)
            _ini_usage $@
            ;;
        *)
            _ini_usage $@
            ;;
    esac
    return $?
}

ini $@
