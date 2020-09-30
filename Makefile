all: bin/pbv

install_destination = /usr/local/bin/pbv

bin/pbv: pbv.swift
	@mkdir -p $(@D)
	xcrun -sdk macosx swiftc $< -O -o $@

install: bin/pbv
	cp $< $(install_destination)

uninstall:
	rm -f $(install_destination)

clean:
	rm -f bin/pbv
