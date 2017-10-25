# bksrv-send

systemd socket service that executes bksrv-send.sh

zfs command requires root access. systemd executes commands with root.
combined these two tools to facilitate zfs backup tasks.

### installation

there is a Makefile that contains
* install - copies file
* enable - calls install then enables the systemd features
* status - what is up
* uninstall

call with sudo as the installed file goto protected regions

sudo make enable


### general

a socket is configured to listen to a designated ip/port
when it recieves a connection it spawns an instance of the bksrv-server@.service
that then will call bksrv-send.sh bash script

there can be multiple snapshot being sent at the same time.

from then we can send back to the socket messages and streams of zfs snapshots

### bksrv-server.sh

`Usage: ./src/bksrv-send.sh [-f frequency=frequent hourly daily weekly monthly] [-p pool] [-s send snapshot]`

this will find the most recent snapshot for a giving frequency
then either echo the name of the snapshot or start a `zfs send` command to stdout.

this script is passed the ip instance data as the only arg when called from service.
subsequent args are found from a read command.


calling this script manually and typing in the command args
```
./bksrv-send.sh
-f daily -p storage/test
storage/test@.....
```

calling into the systemd.socket

`echo "-f weekly -p storage/test" | nc localhost 9999`

will print out the latest snapshot for the given frequency and pool

`echo "-f weekly -p storage/test -s" | nc localhost 9999 | sudo zfs recieve storage/test2`

will send a zfs send snapshot back which can be consumed by `zfs recieve`

### firewall configuration

configure to only allow local subnet ip to the open port

`sudo ufw allow from 192.168.0.0/24 to any port 9999`


