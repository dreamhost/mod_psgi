##
##  Makefile -- Build procedure for PSGI Apache module
##  Autogenerated via ``apxs -n psgi -g''.
##

PACKAGE_NAME=mod_psgi
PACKAGE_VERSION=0.0.1

#   the used tools
APXS=apxs
APACHECTL=apachectl
PERL=perl

builddir=.
top_srcdir=$(shell $(APXS) -q exp_datadir)
top_builddir=$(shell $(APXS) -q exp_datadir)
include $(shell $(APXS) -q installbuilddir)/special.mk

#   additional defines, includes and libraries
ifdef MOD_PSGI_DEBUG
DEBUG_DEFS=-DDEBUG
else
DEBUG_DEFS=
endif
DEFS=-DMOD_PSGI_VERSION=\"$(PACKAGE_VERSION)\" $(DEBUG_DEFS)
INCLUDES=$(shell $(PERL) -MExtUtils::Embed -e ccopts)
LDFLAGS=$(shell $(PERL) -MExtUtils::Embed -e ldopts)

#   the default target
all: local-shared-build

#   install the shared object file into Apache 
install: install-modules-yes

#   cleanup
clean:
	-rm -f mod_psgi.o mod_psgi.lo mod_psgi.slo mod_psgi.la 
	rm -f ppport.h
	$(MAKE) -C t clean

mod_psgi.c: ppport.h

ppport.h:
	perl -MDevel::PPPort -e 'Devel::PPPort::WriteFile'

testconf:
	$(MAKE) -C t conf

test: reload
	$(MAKE) -C t test

#   install and activate shared object by reloading Apache to
#   force a reload of the shared object file
reload: install restart

#   the general Apache start/restart/stop
#   procedures
start:
	$(APACHECTL) start
restart:
	$(APACHECTL) restart
stop:
	$(APACHECTL) stop

DIST_DIR=$(PACKAGE_NAME)-$(PACKAGE_VERSION)
DIST_FILE=$(PACKAGE_NAME)-$(PACKAGE_VERSION).tar
dist: ppport.h
	rm -f $(DIST_FILE)
	git archive --format=tar --prefix=$(DIST_DIR)/ HEAD > $(DIST_FILE)
	mkdir $(DIST_DIR)
	cp ppport.h $(DIST_DIR)
	tar rf $(DIST_FILE) $(DIST_DIR)/ppport.h
	rm -fr $(DIST_DIR)
	gzip --best $(DIST_FILE)

.PHONY: testconf
