PREFIX := /usr/local
SYSTEMD_HOME := $(PREFIX)/lib/systemd/system

all:
	@echo "template unit file"
	@echo "Run 'make status' for status of units "
	@echo "Run 'make install' for copy files into systemd."
	@echo "Run 'make enable' for setup of service."
	@echo "Run 'make uninstall' for uninstallation."
.PHONY: all


install: $(DESTDIR)$(SYSTEMD_HOME)
	install -m 0755 src/bksrv-message-environment $(DESTDIR)$(PREFIX)/etc/bksrv-message-environment
	install -m 0755 src/bksrv-message.sh $(DESTDIR)$(PREFIX)/sbin/bksrv-message.sh
	install -m 0644 -t $(DESTDIR)$(SYSTEMD_HOME) \
		src/bksrv-message.target \
		src/bksrv-message@.service 
.PHONY: install


uninstall:
	systemctl stop bksrv-message.target
	systemctl disable bksrv-message.target
	rm -i $(DESTDIR)$(PREFIX)/etc/bksrv-message-environment
	rm -f $(DESTDIR)$(PREFIX)/sbin/bksrv-message.sh
	rm -f $(DESTDIR)$(SYSTEMD_HOME)/bksrv-message@.service 
	rm -f $(DESTDIR)$(SYSTEMD_HOME)/bksrv-message.target
.PHONY: uninstall


enable: install
	systemctl enable --now bksrv-message.target
	systemctl start bksrv-message.target
	systemctl daemon-reload
.PHONY: enable


status:
	systemctl status bksrv-message*
	systemctl list-units bksrv-message* --all
	systemctl list-unit-files bksrv-message* --all
	test -f $(DESTDIR)$(PREFIX)/etc/bksrv-message-environment && cat $(DESTDIR)$(PREFIX)/etc/bksrv-message-environment
.PHONY:

test:
	@echo "start bksrv-message@.service with hello"
	systemctl start bksrv-message@hello.service
.PHONY: test
