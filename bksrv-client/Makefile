PREFIX := /usr/local
SYSTEMD_HOME := $(PREFIX)/lib/systemd/system

all:
.PHONY: all

install: $(DESTDIR)$(SYSTEMD_HOME)
	install -C -m 0755 src/bksrv-client-environment $(DESTDIR)$(PREFIX)/etc/bksrv-client-environment 
	install -C -m 0755 src/bksrv-client-pools $(DESTDIR)$(PREFIX)/etc/bksrv-client-pools 
	install -m 0755 src/bksrv-client.sh $(DESTDIR)$(PREFIX)/sbin/bksrv-client.sh 
	install -m 0755 src/bksrv-client-backup.sh $(DESTDIR)$(PREFIX)/sbin/bksrv-client-backup.sh 
	install -m 0644 -t $(DESTDIR)$(SYSTEMD_HOME) \
		src/bksrv-client.target \
		src/bksrv-client.timer \
		src/bksrv-client.service \
		src/bksrv-client-backup@.service
.PHONY: install

uninstall:
	systemctl stop bksrv-client.target && systemctl disable bksrv-client.target
	systemctl stop bksrv-client.timer && systemctl disable bksrv-client.timer
	rm -i $(DESTDIR)$(PREFIX)/etc/bksrv-client-environment
	rm -i $(DESTDIR)$(PREFIX)/etc/bksrv-client-pools
	rm -f $(DESTDIR)$(PREFIX)/sbin/bksrv-client.sh
	rm -f $(DESTDIR)$(PREFIX)/sbin/bksrv-client-backup.sh
	rm -f $(DESTDIR)$(SYSTEMD_HOME)/bksrv-client.target
	rm -f $(DESTDIR)$(SYSTEMD_HOME)/bksrv-client.timer
	rm -f $(DESTDIR)$(SYSTEMD_HOME)/bksrv-client.service
	rm -f $(DESTDIR)$(SYSTEMD_HOME)/bksrv-client-backup@.service
	sudo systemctl reset-failed bksrv-client*
	systemctl daemon-reload
.PHONY: uninstall

$(DESTDIR)$(SYSTEMD_HOME):
	mkdir -p $(DESTDIR)$(SYSTEMD_HOME)
.PHONY: $(DESTDIR)$(SYSTEMD_HOME)

enable: install
	systemctl enable bksrv-client.timer && systemctl start bksrv-client.timer
	systemctl enable bksrv-client.target && systemctl start bksrv-client.target
	systemctl daemon-reload
.PHONY: enable

status:
	systemctl status bksrv-client*
	systemctl list-units bksrv-client.target
	systemctl list-unit-files bksrv-client.target --all
	systemctl list-timers bksrv-client* --all
	test -f $(DESTDIR)$(PREFIX)/etc/bksrv-client-environment && cat $(DESTDIR)$(PREFIX)/etc/bksrv-client-environment
.PHONY:


