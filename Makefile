# Source directory.
srcdir=.

# Where to install things.
PREFIX="$HOME/easy-yorick"

# C compiler to use, flags to compile and to link.
CC=gcc
CFLAGS='-pipe -Wall -O2 -fomit-frame-pointer'
LDFLAGS=''

default:
	@echo "No default target.  Try 'make install'."

install:
	mkdir -p "${PREFIX}/bin"
	rm -f "${PREFIX}/bin/ypkg"
	sed <"${srcdir}/ypkg" >"${PREFIX}/bin/ypkg" \
	    -e 's%^\( *\(export  *\|\)PREFIX=\).*%\1"${PREFIX}"%' \
	    -e 's%^\( *\(export  *\|\)CC=\).*%\1"${CC}"%' \
	    -e 's%^\( *\(export  *\|\)CFLAGS=\).*%\1"${CFLAGS}"%' \
	    -e 's%^\( *\(export  *\|\)LDFLAGS=\).*%\1"${LDFLAGS}"%'
	chmod 755 "${PREFIX}/bin/ypkg"
	mkdir -p "${PREFIX}/etc/ypkg"
	touch "${PREFIX}/etc/ypkg/MANIFEST"
	mkdir -p "${PREFIX}/src"
