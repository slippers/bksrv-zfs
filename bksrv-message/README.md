# bksrv-message

systemd service that emails the systemd log for a failed unit

### files

`src/bksrv-message.sh`

bash script to call sendmail.
args passed in from service.

`src/bksrv-message@.service`

systemd service that calls the bksrv-message.sh script

`src/bksrv-message-environment`

config file for the bksrv-message service.
this is where you specify the email to send status messages to.

### install and enable

`sudo make enable` calls install and enables units

### uninstall
 
`sudo make uninstall`

### test
 
`sudo make test`

calls the bksrv-message service with 'hello' param.
