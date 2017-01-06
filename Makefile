all:
	@echo 'Valid targets are:'
	@echo '  pbv'
	@echo '  install'
	@echo '  clean'

pbv: pbv.swift
	xcrun -sdk macosx swiftc $< -O -o $@

install: pbv
	cp pbv /usr/local/bin/pbv

clean:
	rm -f pbv
