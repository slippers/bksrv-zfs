#!/bin/bash

read -r args

set -- $args "$@"

printf %q "params:${@}" | logger

backup=(frequent hourly daily weekly monthly)
actions=(list send increamental)
action=${actions[0]}

usage() {
    echo "Usage: $0 [-f frequency=${backup[*]}] [-p pool] [-s send snapshot] [-i increamental snapshot]"
    exit 1
}

while getopts f:p:s::i:: o
do
    case "${o}" in
        f)
            frequency=${OPTARG}
			;;
        p)
            pool=${OPTARG}
            ;;
        s)
            action=${actions[1]}
            snapshot=${OPTARG}
            ;;
        i)
            action=${actions[2]}
            snapshot=${OPTARG}
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

newestsnapshot=`zfs list -t snapshot -o name -s creation -r $pool | grep $frequency | tail -1`

if [ -x ${snapshot} ]
then
    $snapshot = $newestsnapshot
fi

if [ "$action" == "${actions[0]}" ]
then
    echo "$newestsnapshot"
fi

if [ "$action" == "${actions[1]}" ]
then
    zfs send -R $snapshot
fi

if [ "$action" == "${actions[2]}" ]
then
    zfs send -R -i $snapshot $newestsnapshot
fi
