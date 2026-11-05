all: vt05 vt52 vt50 dp3300 gecon dm2500
BINARIES=vt05 vt52 vt50 dp3300 gecon dm2500
VERSION=1.0
BUILDDIR=$(CURDIR)/build
TARBALL=vt05-$(VERSION).tar.gz
.PHONY: all clean dist rpm distclean
CC?=cc
CFLAGS?=-O3
WARN=-Wall -Wno-unused-parameter -Wno-parentheses -Wno-unused-result
DEPS=`sdl2-config --libs --cflags` -lm -lpthread
vt05: vt05.c terminal.c vt05chars.h args.h
	$(CC) $(CFLAGS) $(WARN) -fpie -pie -o vt05 vt05.c terminal.c $(DEPS)
vt52: vt52.c terminal.c vt52rom.h args.h
	$(CC) $(CFLAGS) $(WARN) -fpie -pie -o vt52 vt52.c terminal.c $(DEPS)
vt50: vt50.c terminal.c vt52rom.h args.h
	$(CC) $(CFLAGS) $(WARN) -fpie -pie -o vt50 vt50.c terminal.c $(DEPS)
dp3300: dp3300.c terminal.c dpchars.h args.h
	$(CC) $(CFLAGS) $(WARN) -fpie -pie -o dp3300 dp3300.c terminal.c $(DEPS)
gecon: gecon.c terminal.c dpchars.h args.h
	$(CC) $(CFLAGS) $(WARN) -fpie -pie -o $@ gecon.c terminal.c $(DEPS)
dm2500: dm2500.c terminal.c dmchars.h args.h
	$(CC) $(CFLAGS) $(WARN) -fpie -pie -o dm2500 dm2500.c terminal.c $(DEPS)
clean:
	rm -f $(BINARIES)

dist: clean
	git archive --prefix=vt05-$(VERSION)/ --format=tar HEAD | gzip > $(TARBALL)

rpm: dist
	rpmbuild -ba vt05.spec \
		--define "_topdir $(BUILDDIR)" \
		--define "_sourcedir $(CURDIR)" \
		--define "_specdir $(CURDIR)"

distclean: clean
	rm -rf $(BUILDDIR) $(TARBALL)
