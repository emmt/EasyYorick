#
# Build and install scripts for MiRA.
#
# Dependencies:
#
#     ypkg install yorick yeti optimpacklegacy ylib ipy yoifits
#

ypkg_define "mira" "https://github.com/emmt/MiRA.git"

clone_mira() {
    if ! test -d "$SRCDIR/mira"
    then
        cd "$SRCDIR"
        git clone "$MIRA_ORIGIN" mira
    fi
}

update_mira() {
    test -e "$SRCDIR/mira" || clone_mira
    cd "$SRCDIR/mira"
    git pull -r
}

config_mira() {
    local status
    # Call `ypkg_install` to install required packages.
    ypkg_install yorick yeti optimpacklegacy ylib ipy yoifits
    status=$(ypkg_status ynfft)
    if ! test "$status" = "installed" -o "$status" = "upgradable"
    then
        ypkg_warn "You should also install package \"ynfft\""
    fi
    test -e "$SRCDIR/mira" || clone_mira
    cd "$SRCDIR/mira"
    ./configure --prefix="$PREFIX" --yorick="$YORICK_EXE" \
                --mandir="$MANDIR" --bindir="$BINDIR"
}

build_mira() {
    test -f "$SRCDIR/mira/install.cfg" || config_mira
    cd "$SRCDIR/mira"
    make clean
    make
}

install_mira() {
    test -f "$SRCDIR/mira/install.cfg" || config_mira
    cd "$SRCDIR/mira"
    make install
}
