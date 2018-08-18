# Copyright (C) 2018 Sven Arvidsson
# Copyright (C) 2016-2017 Björn Spindel
# This file is part of libdark, originally based on the
# makefile from libstrangle.

# libdark is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# libdark is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with libdark.  If not, see <http://www.gnu.org/licenses/>.

CC=gcc
CFLAGS=-shared -fPIC -Wall -std=gnu11
#CFLAGS=-rdynamic -fPIC -shared -Wall -std=c99 -fvisibility=hidden -DHOOK_DLSYM
LDFLAGS=-Wl,-z,relro,-z,now
LDLIBS=-ldl -lrt -lX11
#-lX11
prefix=/usr/local
bindir=$(prefix)/bin
libdir=$(prefix)/lib
DOC_PATH=$(prefix)/share/doc/dark
LIB32_PATH=$(libdir)/libdark/lib32
LIB64_PATH=$(libdir)/libdark/lib64
SOURCEDIR=src/
BUILDDIR=build/
SOURCES=$(wildcard $(SOURCEDIR)*.c)

all: $(BUILDDIR)libdark64.so $(BUILDDIR)libdark32.so $(BUILDDIR)libdark.conf

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

$(BUILDDIR)libdark.conf: $(BUILDDIR)
	@echo "$(LIB32_PATH)/" > $(BUILDDIR)libdark.conf
	@echo "$(LIB64_PATH)/" >> $(BUILDDIR)libdark.conf

$(BUILDDIR)libdark64.so: $(BUILDDIR)
	$(CC) $(CFLAGS) $(LDFLAGS) -m64 -o $(BUILDDIR)libdark64.so $(SOURCES) $(LDLIBS)

$(BUILDDIR)libdark32.so: $(BUILDDIR)
	$(CC) $(CFLAGS) $(LDFLAGS) -m32 -o $(BUILDDIR)libdark32.so $(SOURCES) $(LDLIBS)

install: all
	install -m 0644 -D -T $(BUILDDIR)libdark.conf $(DESTDIR)/etc/ld.so.conf.d/libdark.conf
	install -m 0755 -D -T $(BUILDDIR)libdark32.so $(DESTDIR)$(LIB32_PATH)/libdark.so
	install -m 0755 -D -T $(BUILDDIR)libdark64.so $(DESTDIR)$(LIB64_PATH)/libdark.so
#	install -m 0644 -D -T COPYING $(DESTDIR)$(DOC_PATH)/LICENSE
	ldconfig

clean:
	rm -f $(BUILDDIR)libdark64.so
	rm -f $(BUILDDIR)libdark32.so
	rm -f $(BUILDDIR)libdark.conf

uninstall:
	rm -f $(DESTDIR)/etc/ld.so.conf.d/libdark.conf
	rm -f $(DESTDIR)$(LIB32_PATH)/libdark.so
	rm -f $(DESTDIR)$(LIB64_PATH)/libdark.so
#	rm -f $(DESTDIR)$(DOC_PATH)/LICENSE
