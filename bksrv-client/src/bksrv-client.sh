#!/bin/bash

usage() { 
    echo "Usage: $0 [-p pools ] " 1>&2;
    echo "pools is a tab separated file" 1>&2;
    echo "pool_id server pool" 1>&2;
    exit 1; 
}

while getopts "p:" o; do
    case "${o}" in
        p)
            pools=${OPTARG}
			;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if ! [ -f "$pools" ]; then
    usage
fi

while read -r pool_id server pool
do
    echo "id=${pool_id} server=${server} pool=${pool}"
    # check if bksrv-client-backup is already running for this server/pool
    #   skip if it is
    #   passing just the id from the pools file to the service
    systemctl is-active bksrv-client-backup@${pool_id}.service || {
        echo "starting id=${pool_id} server=${server} pool=${pool}"
        systemctl start bksrv-client-backup@${pool_id}.service
    }
done < $pools
