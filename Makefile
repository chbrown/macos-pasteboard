all:
	@echo 'Valid targets are:'
	@echo '  pbv'
	@echo '  install'
	@echo '  uninstall'
	@echo '  clean'

install_destination = /usr/local/bin/pbv

pbv: pbv.swift
	xcrun -sdk macosx swiftc $< -O -o $@

install: pbv
	cp pbv $(install_destination)

uninstall:
	rm -f $(install_destination)

clean:
	rm -f pbv
