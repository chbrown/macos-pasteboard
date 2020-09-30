INSTALL ?= install
prefix ?= /usr/local
bindir ?= $(prefix)/bin
CFLAGS := -O

all: bin/pbv

bin/pbv: $(wildcard *.swift)
	@mkdir -p $(@D)
	xcrun -sdk macosx swiftc $+ $(CFLAGS) -o $@

install: bin/pbv
	$(INSTALL) $< $(DESTDIR)$(bindir)

uninstall:
	rm -f $(DESTDIR)$(bindir)/pbv

clean:
	rm -f bin/pbv
