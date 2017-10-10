#!/bin/bash

read -r args

set -- $args "$@"

printf %q "params:${@}" | logger

backup=(frequent hourly daily weekly monthly)
action="list"

usage() {
    echo "Usage: $0 [-f frequency=${backup[*]}] [-p pool] [-s send snapshot]"
    exit 1
}

while getopts f:p:s:: o
do
    case "${o}" in
        f)
            frequency=${OPTARG}
			;;
        p)
            pool=${OPTARG}
            ;;
        s)
            action="send"
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))


if [ -z "${frequency}" ]; then
    usage
fi

if [ -z "${pool}" ]; then
    usage
fi

snapshot=`zfs list -t snapshot -o name -s creation -r $pool | grep $frequency | tail -1`


if [ "$action" == "list" ]
then
    echo "$snapshot"
fi

if [ "$action" == "send" ]
then
    zfs send $snapshot
fi
