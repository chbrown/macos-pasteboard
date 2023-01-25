INSTALL ?= install
prefix ?= /usr/local
bindir ?= $(prefix)/bin
CFLAGS := -O

all: bin/pbv bin/pbc

bin/pbv: pbv.swift
	@mkdir -p $(@D)
	xcrun -sdk macosx swiftc $+ $(CFLAGS) -o $@

bin/pbc: pbc.swift
	@mkdir -p $(@D)
	xcrun -sdk macosx swiftc $+ $(CFLAGS) -o $@

install: bin/pbv bin/pbc
	$(INSTALL) $^ $(DESTDIR)$(bindir)

uninstall:
	rm -f $(DESTDIR)$(bindir)/pbv
	rm -f $(DESTDIR)$(bindir)/pbc

clean:
	rm -f bin/pbv bin/pbc

test:
	swiftformat --lint *.swift
	swiftlint lint *.swift
