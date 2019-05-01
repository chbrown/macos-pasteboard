all:
	@echo 'Valid targets are:'
	@echo '  pbv'
	@echo '  install'
	@echo '  uninstall'
	@echo '  clean'

install_destination = /usr/local/bin/pbv

pbv: pbv.swift
	xcrun -sdk macosx swiftc $< -O -o $@

.PHONY: install
install: pbv
	cp pbv $(install_destination)

.PHONY: uninstall
uninstall:
	rm -f $(install_destination)

.PHONY: clean
clean:
	rm -f pbv
