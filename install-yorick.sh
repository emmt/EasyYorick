#! /bin/sh
#
# install-yorick.sh --
#
# Script to automatically download sources, compile and install Yorick and some
# extensions (among others MiRA https://github.com/emmt/MiRA).
#
# *IMPORTANT* Edit this script to match your needs.  In particular you want
#             to choose SRCDIR and PREFIX.
#
# *IMPORTANT* Install required libraries and headers.  On Ubuntu:
#
#                 sudo apt-get install libfftw3-dev libnfft3-dev
#

# Where to install everything (can be moved later, the sources --see below --
# can be elsewhere).
PREFIX=$HOME/easy-yorick

# Where to install the sources.
SRCDIR=$PREFIX/src

# Do you have texi2html?
HAVE_TEXI2HTML=no

# Do you want Yeti?
WANT_YETI=yes

# Do you want MiRA (this requires Yeti)?
WANT_MIRA=yes

# URLs of code repositories.
YORICK_GIT="https://github.com/dhmunro/yorick.git"
YETI_GIT="https://github.com/emmt/Yeti.git"
OPTIMPACKLEGACY_GIT="https://github.com/emmt/OptimPackLegacy.git"
YNFFT_GIT="https://github.com/emmt/ynfft.git"
MIRA_GIT="https://github.com/emmt/MiRA.git"

# In principle, the following does not need changes.  But you can
# have a look to see what will happen if you run this script.

LIBDIR="$PREFIX/lib"
LIBEXECDIR="$PREFIX/libexec"
BINDIR="$PREFIX/bin"
SHAREDIR="$PREFIX/share"
MANDIR="$SHAREDIR/man"
YORICK_EXE="$LIBEXECDIR/yorick/bin/yorick"

mkdir -p "$PREFIX"
mkdir -p "$SRCDIR"

#______________________________________________________________________
#
# Build and install Yorick.
#
if ! test -d "$SRCDIR/yorick"
then
    cd "$SRCDIR" yorick
    git clone "$YORICK_GIT"
fi
cd "$SRCDIR/yorick"
git pull
export CC=gcc
export CFLAGS='-pipe -Wall -O2 -fomit-frame-pointer'
make Y_HOME=relocate ysite "CFLAGS=$CFLAGS" "CC=$CC"
make config "CFLAGS=$CFLAGS" "CC=$CC"
make clean
make -j4
make install
cp -p install.rel relocate/README
cp -p play/libplay.* relocate/lib/.
cp -p gist/libgist.* relocate/lib/.
chmod 644 relocate/include/*.h
mkdir -p relocate/contrib
mv relocate/doc/README relocate/doc/CONTENTS
cp -p LICENSE.md ONEWS README.md TODO VERSION relocate/doc/.
cp -p gist/README relocate/doc/README.gist
cp -p play/README relocate/doc/README.play
if test "$HAVE_TEXI2HTML" = "yes"
then
    cd doc/html
    make
    cd ../..
    tar cf - doc/html doc/refs-html | tar xf - -C relocate
fi
find relocate -type d -exec chmod 755 {} \;
find relocate -type f -exec chmod ugo+r {} \;
mkdir -p relocate/emacs
cp -p emacs/README emacs/*.el relocate/emacs/.
emacs --batch relocate/emacs/yorick.el -f emacs-lisp-byte-compile
mkdir -p "$LIBEXECDIR"
rm -f "$LIBEXECDIR/yorick"
mv relocate "$LIBEXECDIR/yorick"
if test -L "$BINDIR/yorick" -o ! -e "$BINDIR/yorick"
then
    rm -f "$BINDIR/yorick"
    ln -s "$LIBEXECDIR/yorick/bin/yorick" "$BINDIR/yorick"
fi

#______________________________________________________________________
#
# Build and install Yeti.
#
if test x"$WANT_YETI" = xyes -o x"$WANT_MIRA" = xyes
then
    if ! test -d "$SRCDIR/yeti"
    then
        cd "$SRCDIR"
        git clone "$YETI_GIT" yeti
    fi
    cd "$SRCDIR/yeti"
    git pull
    ./configure --yorick="$YORICK_EXE"
    make clean
    make -j4 all
    make install
fi

#______________________________________________________________________
#
# Build and install OptimPackLegacy.
#
if test x"$WANT_MIRA" = xyes
then
    if ! test -d "$SRCDIR/optimpacklegacy"
    then
        cd "$SRCDIR"
        git clone "$OPTIMPACKLEGACY_GIT" optimpacklegacy
    fi
    cd "$SRCDIR/optimpacklegacy"
    git pull
    mkdir -p "$SRCDIR/optimpacklegacy/yorick/build"
    cd "$SRCDIR/optimpacklegacy/yorick/build"
    ../configure --yorick="$YORICK_EXE"
    make clean
    make -j4 all
    make install
fi

#______________________________________________________________________
#
# Build and install YNFFT.
#
# To install nfft libraries:
#
#     sudo apt-get install libfftw3-dev libnfft3-dev
#
if test x"$WANT_MIRA" = xyes
then
    if ! test -d "$SRCDIR/ynfft"
    then
        cd "$SRCDIR"
        git clone "$YNFFT_GIT" ynfft
    fi
    cd "$SRCDIR/ynfft"
    git pull
    mkdir -p "$SRCDIR/ynfft/build"
    cd "$SRCDIR/ynfft/build"
    ../configure --yorick="$YORICK_EXE"
    make clean
    make all
    make install
fi

#______________________________________________________________________
#
# Build and install MiRA.
#
if test x"$WANT_MIRA" = xyes
then
    if ! test -d "$SRCDIR/mira"
    then
        cd "$SRCDIR"
        git clone "$MIRA_GIT" mira
        cd "$SRCDIR/mira"
        git submodule init
        git submodule update
        git submodule foreach 'git checkout master'
    fi
    cd "$SRCDIR/mira"
    git pull
    git submodule foreach 'git pull'
    for subdir in ipy ylib yoifits
    do
        mkdir -p "$SRCDIR/mira/lib/$subdir/build"
        cd "$SRCDIR/mira/lib/$subdir/build"
        ../configure --yorick="$YORICK_EXE"
        make clean
        make
        make install
    done
    cd "$SRCDIR/mira"
    ./configure --yorick="$YORICK_EXE" --bindir="$BINDIR" --mandir="$MANDIR"
    make clean
    make install
fi
