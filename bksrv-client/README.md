# bksrv-client

this client uses the systemd.timer to execute a daily backup

environment confgured with a list of host/pool/frequency to backup

the first backup where the pool does not exist on client is a full pull.
subsequent pulls are incremental.

this can be a long running process so each host/pool/frequency to
backup will get its own service instance.

two services?  
one to loop through all the host/pool/frequency and
spawn a service template.  

another service template to process the backup request


### backup exchange

there is a list of host/pool/frequency to backup



for each pool@host-frequency to backup
    get the last snapshot from the pool on client
        if no pool or snap then full backup
        if pool and snap
            backup incremental

    `snapshot=$(echo "-f $frequency -p $pool" | nc $host 9999)`
    if snapshot not already in backup zfs -> continue 

    `echo "-f $frequency -p $pool -s" | nc $host 9999 | zfs recieve $pool`


### parts and pieces

bksrv-client.timer
* calls bksrv-client.service
* defines when to call the service (once a day?)

bksrv-client.service
* consumes an environment file that defines the host/pool/frequency
* call a template service to do the actual backup

bksrv-client-backup@.service
* consumes host/pool/frequency
* is instance of this service with this strategy running (exit)
* determines the backup strategy none/full/incremental

bksrv-client.sh
* called by bksrv-client.service

bksrv-client-backup.sh
* called by bksrv-client-backup@.service
