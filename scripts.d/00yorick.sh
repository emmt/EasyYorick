#
# Build and install scripts for Yorick.
#

if test "$YORICK_BRANCH" = "emmt"; then
    ypkg_define "yorick" "https://github.com/emmt/yorick.git"
else
    if test "$YORICK_BRANCH" != "master"; then
        ypkg_warn "variable YORICK_BRANCH should be \"master\" or \"emmt\""
        YORICK_BRANCH="master"
    fi
    ypkg_define "yorick" "https://github.com/LLNL/yorick.git"
fi

clone_yorick() {
    if ! test -d "$SRCDIR/yorick"
    then
        cd "$SRCDIR"
        git clone "$YORICK_ORIGIN" yorick
    fi
}

update_yorick() {
    clone_yorick
    cd "$SRCDIR/yorick"
    git checkout "$YORICK_BRANCH"
    git pull -r
}

config_yorick() {
    clone_yorick
    cd "$SRCDIR/yorick"
    git checkout "$YORICK_BRANCH"
    make Y_HOME=relocate ysite "CFLAGS=$CFLAGS" "CC=$CC"
    make config "CFLAGS=$CFLAGS" "CC=$CC"
}

build_yorick() {
    test -f "$SRCDIR/yorick/Make.cfg" || config_yorick
    cd "$SRCDIR/yorick"
    git checkout "$YORICK_BRANCH"
    make clean
    make -j4
}

install_yorick() {
    test -x "$SRCDIR/yorick/yorick/yorick" || build_yorick
    cd "$SRCDIR/yorick"
    git checkout "$YORICK_BRANCH"
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
    emacs=$(ypkg_find_executable "emacs")
    if test ! -z "$emacs"; then
        $emacs --batch relocate/emacs/yorick.el -f emacs-lisp-byte-compile
    fi
    mkdir -p "$LIBEXECDIR"
    if test "$PRESERVE_OTHER_INSTALLED_FILES" = "yes"
    then
        mkdir -p "$LIBEXECDIR/yorick"
        cd "$SRCDIR/yorick/relocate"
        tar cf - . | tar -C "$LIBEXECDIR/yorick/" -xf -
    else
        rm -rf "$LIBEXECDIR/yorick"
        mv relocate "$LIBEXECDIR/yorick"
    fi
    if test -L "$BINDIR/yorick" -o ! -e "$BINDIR/yorick"
    then
        rm -f "$BINDIR/yorick"
        ln -s "../libexec/yorick/bin/yorick" "$BINDIR/yorick"
    fi
}
