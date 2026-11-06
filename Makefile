all: vt05 vt52 vt50 dp3300 gecon dm2500
BINARIES=vt05 vt52 vt50 dp3300 gecon dm2500
NAME=vt05
VERSION=1.0
TARBALL=$(NAME)-$(VERSION).tar.gz
DIST_DIR=dist
RPM_DIR=dist-rpm
.PHONY: all clean dist rpm
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
	-rm -f $(BINARIES)
	-rm -rf $(DIST_DIR) $(RPM_DIR)

dist:
	mkdir -p $(DIST_DIR)
	git archive --prefix=$(NAME)-$(VERSION)/ --format=tar HEAD | gzip > $(DIST_DIR)/$(TARBALL)

rpm: dist
	mkdir -p $(RPM_DIR)
	rpmbuild -ba \
		--define "_sourcedir $(CURDIR)/$(DIST_DIR)" \
		--define "_rpmdir $(CURDIR)/$(RPM_DIR)" \
		--define "_srcrpmdir $(CURDIR)/$(RPM_DIR)" \
		--define "_rpmfilename %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm" \
		$(NAME).spec
