#!/bin/bash

echo "bksrv-snapshot bash script."
echo "$@"

backup=(frequent hourly daily weekly monthly)

usage() { echo "Usage: $0 [-b ${backup[*]}] [-i pools]" 1>&2; exit 1; }

while getopts ":b:i:" o; do
    case "${o}" in
        b)
            b=${OPTARG}
			;;
        i)
            i=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

echo "b = ${b}"
echo "i = ${i}"

if [ -z "${b}" ]; then
    usage
fi

if [ -z "${i}" ]; then
    echo "pools not set for backup"
    exit
fi

case "${b}" in
  "frequent")
    ;;
  "hourly")
	/usr/local/sbin/zfsnap snapshot -a 2d -p $(hostname)-hourly- -rv ${i}
    ;;
  "daily")
	/usr/local/sbin/zfsnap snapshot -a 1w -p $(hostname)-daily- -rv ${i}
    ;;
  "weekly")
	/usr/local/sbin/zfsnap snapshot -a 1m -p $(hostname)-weekly- -rv ${i}
    ;;
  "monthly")
	/usr/local/sbin/zfsnap snapshot -a 3m -p $(hostname)-monthly- -rv ${i}
    ;;
  *)
    usage 
    ;;
esac

/usr/local/sbin/zfsnap destroy -rvsS ${i} 
