# bksrv systemd timer services

execute commands to take [zfs snapshots](http://open-zfs.org/wiki/Developer_resources) 
via the [zfsnap](http://www.zfsnap.org/) tool on a scheduled basis using systemd.

## general

bkserv is a systemd service that calls a bash script.
it is deployed with a set of systemd timers to execute the service
on a frequency basis.

[bksrv](https://github.com/slippers/bksrv) uses [status-email-user](https://github.com/slippers/status-email-user)
to send email alerts on script failures. bksrv service template calls a bash script bksrv.sh which calls the zfsnap commands

## setup

install zfsnap
* [zfsnap](http://www.zfsnap.org/)
* clone from their repo

setup status-email-user
* `git clone https://github.com/slippers/status-email-user`
* `sudo make install`
* configure admin email

setup bksrv
* `git clone https://github.com/slippers/bksrv`
* `sudo make install`
* configure the `/usr/local/etc/bksrv-environment`
* `sudo make enable`
* check status of timers `sudo make status`
 
## bksrv-environment

`/usr/local/etc/bksrv-environment` contains a set of environment variables

assign a set of pools for each frequency like this.

'''
bksrv_frequent=
bksrv_hourly=storage/pictures
bksrv_daily=storage/users storage/data storage/pictures
bksrv_weekly=storage/users storage/data storage/pictures
bksrv_monthly=storage/users storage/data storage/pictures
'''

not setting a varible is ok. script will exit quietly.

these params are passed to the bksrv.sh script.

make install script should not overwrite your changes

### uninstall

`sudo make uninstall`

### status
 
to see what timers are now active

`sudo make status`

to see the systemd log

`journalctl -xe`

### help

check out the systemd man pages like so...
'''
man systemd.service
man systemd.timers
'''

https://jason.the-graham.com/2013/03/06/how-to-use-systemd-timers/
https://wiki.archlinux.org/index.php/Systemd#Handling_dependencies
http://kbdone.com/zfs-snapshots-clones/


