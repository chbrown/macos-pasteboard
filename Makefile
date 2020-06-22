all:
	@printf 'Valid targets are:\n'
	@printf '  %s\n' pbv install uninstall clean

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
