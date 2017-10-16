#!/bin/bash

echo "$0=$@"

usage() { 
    echo "Usage: $0 -p pools -i pool_id" 1>&2;
    exit 1; 
}

while getopts "p:i:" o; do
    case "${o}" in
        p)
            pools=${OPTARG}
            ;;
        i)
            pool_id=${OPTARG}
			;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if ! [ -f "$pools" ]; then
    echo "pools"
    usage
fi

if [ -z "$pool_id" ]; then
    echo "pool_id"
    usage
fi

echo "pools=$pools pool_id=$pool_id"

# extract the server and pool from file and set variables
declare $(awk '{
    if (/^'$pool_id'/)
    {
        print "server="$2;
        print "port="$3;
        print "pool="$4;
        print "frequency="$5;
        exit;
    }
    else
    {
        print "server=";
        print "port=";
        print "pool="; 
        print "frequency=";
    }
}' $pools )

if [ -z "$server" ]; then
    echo "server not defined in pools file."
    exit 1
fi

if [ -z "$port" ]; then
    echo "port not defined in pools file."
    exit 1
fi

if [ -z "$pool" ]; then
    echo "pool not defined in pools file."
    exit 1
fi

if [ -z "$frequency" ]; then
    echo "frequency not defined in pools file."
    exit 1
fi


echo "server=$server port=$port pool=$pool"

local_snapshot=$(zfs list -t snapshot -o name -s creation -r $pool | grep $frequency | tail -1)
echo $local_snapshot
remote_snapshot=$(echo "-f $frequency -p $pool" | nc $server $port)
echo $remote_snapshot

if ! [ "$local_snapshot" == "$remote_snapshot" ]
then
    echo "incremental $local_snapshot => $remote_snapshot"
    echo "-f $frequency -p $pool -i $local_snapshot" | nc $server $port | zfs receive $pool
fi
