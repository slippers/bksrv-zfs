#!/bin/bash

if [ -z "$1" ]; then
    echo "email address not set"
    exit
fi

/usr/sbin/sendmail -vt <<ERRMAIL
To: $1
From: systemd <root@$HOSTNAME>
Subject: $2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8

$(systemctl status --full "$2")
ERRMAIL
