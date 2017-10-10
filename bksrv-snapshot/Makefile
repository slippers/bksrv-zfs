PREFIX := /usr/local
SYSTEMD_HOME := $(PREFIX)/lib/systemd/system

all:
.PHONY: all

install: $(DESTDIR)$(SYSTEMD_HOME)
	install -C -m 0755 src/bksrv-snapshot-environment $(DESTDIR)$(PREFIX)/etc/bksrv-snapshot-environment 
	install -m 0755 src/bksrv-snapshot.sh $(DESTDIR)$(PREFIX)/sbin/bksrv-snapshot.sh 
	install -m 0644 -t $(DESTDIR)$(SYSTEMD_HOME) \
		src/bksrv-snapshot.target \
		src/bksrv-snapshot-daily.timer \
		src/bksrv-snapshot-frequent.timer \
		src/bksrv-snapshot-hourly.timer \
		src/bksrv-snapshot-monthly.timer \
		src/bksrv-snapshot-weekly.timer \
		src/bksrv-snapshot@.service
.PHONY: install

uninstall:
	systemctl stop bksrv-snapshot.target && systemctl disable bksrv-snapshot.target
	systemctl stop bksrv-snapshot-frequent.timer && systemctl disable bksrv-snapshot-frequent.timer
	systemctl stop bksrv-snapshot-hourly.timer && systemctl disable bksrv-snapshot-hourly.timer
	systemctl stop bksrv-snapshot-daily.timer && systemctl disable bksrv-snapshot-daily.timer
	systemctl stop bksrv-snapshot-weekly.timer && systemctl disable bksrv-snapshot-weekly.timer
	systemctl stop bksrv-snapshot-monthly.timer && systemctl disable bksrv-snapshot-monthly.timer
	rm -i $(DESTDIR)$(PREFIX)/etc/bksrv-snapshot-environment
	rm -f $(DESTDIR)$(PREFIX)/sbin/bksrv-snapshot.sh
	rm -f $(DESTDIR)$(SYSTEMD_HOME)/bksrv-snapshot.target
	rm -f $(DESTDIR)$(SYSTEMD_HOME)/bksrv-snapshot-daily.timer
	rm -f $(DESTDIR)$(SYSTEMD_HOME)/bksrv-snapshot-frequent.timer 
	rm -f $(DESTDIR)$(SYSTEMD_HOME)/bksrv-snapshot-hourly.timer
	rm -f $(DESTDIR)$(SYSTEMD_HOME)/bksrv-snapshot-monthly.timer
	rm -f $(DESTDIR)$(SYSTEMD_HOME)/bksrv-snapshot-weekly.timer
	rm -f $(DESTDIR)$(SYSTEMD_HOME)/bksrv-snapshot@.service
	sudo systemctl reset-failed bksrv-snapshot*
	systemctl daemon-reload
.PHONY: uninstall

$(DESTDIR)$(SYSTEMD_HOME):
	mkdir -p $(DESTDIR)$(SYSTEMD_HOME)
.PHONY: $(DESTDIR)$(SYSTEMD_HOME)

enable: install
	systemctl enable bksrv-snapshot-frequent.timer && systemctl start bksrv-snapshot-frequent.timer
	systemctl enable bksrv-snapshot-hourly.timer && systemctl start bksrv-snapshot-hourly.timer
	systemctl enable bksrv-snapshot-daily.timer && systemctl start bksrv-snapshot-daily.timer
	systemctl enable bksrv-snapshot-weekly.timer && systemctl start bksrv-snapshot-weekly.timer
	systemctl enable bksrv-snapshot-monthly.timer && systemctl start bksrv-snapshot-monthly.timer
	#systemctl start bksrv-snapshot@.service && systemctl start bksrv-snapshot@.service
	systemctl enable bksrv-snapshot.target && systemctl start bksrv-snapshot.target
	systemctl daemon-reload
.PHONY: enable

status:
	systemctl status bksrv-snapshot*
	systemctl list-units bksrv-snapshot.target
	systemctl list-unit-files bksrv-snapshot.target --all
	systemctl list-timers bksrv-snapshot* --all
	test -f $(DESTDIR)$(PREFIX)/etc/bksrv-snapshot-environment && cat $(DESTDIR)$(PREFIX)/etc/bksrv-snapshot-environment
.PHONY:


