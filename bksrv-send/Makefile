PREFIX := /usr/local
SYSTEMD_HOME := $(PREFIX)/lib/systemd/system

all:
.PHONY: all

install: $(DESTDIR)$(SYSTEMD_HOME)
	install -C -m 0755 src/bksrv-send-environment $(DESTDIR)$(PREFIX)/etc/bksrv-send-environment
	install -m 0755 src/bksrv-send.sh $(DESTDIR)$(PREFIX)/sbin/bksrv-send.sh
	install -m 0644 -t $(DESTDIR)$(SYSTEMD_HOME) \
		src/bksrv-send@.service \
		src/bksrv-send.socket \
		src/bksrv-send.target
.PHONY: install

uninstall:
	systemctl stop bksrv-send.target && systemctl disable bksrv-send.target
	systemctl stop bksrv-send.socket && systemctl disable bksrv-send.socket
	rm -i $(DESTDIR)$(PREFIX)/etc/bksrv-send-environment
	rm -f $(DESTDIR)$(PREFIX)/sbin/bksrv-send.sh
	rm -f $(DESTDIR)$(SYSTEMD_HOME)/bksrv-send.socket
	rm -f $(DESTDIR)$(SYSTEMD_HOME)/bksrv-send@.service
	rm -f $(DESTDIR)$(SYSTEMD_HOME)/bksrv-send.target
	systemctl daemon-reload 
.PHONY: uninstall

$(DESTDIR)$(SYSTEMD_HOME):
	mkdir -p $(DESTDIR)$(SYSTEMD_HOME)
.PHONY: $(DESTDIR)$(SYSTEMD_HOME)

enable: install
	systemctl enable bksrv-send.socket && systemctl start bksrv-send.socket
	systemctl enable bksrv-send.target && systemctl start bksrv-send.target
	systemctl daemon-reload 
.PHONY: enable

status:
	systemctl status bksrv-send*
	systemctl list-sockets bksrv-send*
	systemctl list-units bksrv-send*
	systemctl list-unit-files bksrv-send*
.PHONY:


