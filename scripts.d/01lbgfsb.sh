#
# Build and install scripts for Yorick plug-in to L-BFGS-B.
#

ypkg_define "lbfgsb" "https://github.com/emmt/c-lbfgsb.git"

clone_lbfgsb() {
    if ! test -d "$SRCDIR/lbfgsb"
    then
        cd "$SRCDIR"
        git clone "$LBFGSB_ORIGIN" lbfgsb
    fi
}

update_lbfgsb() {
    clone_lbfgsb
    cd "$SRCDIR/lbfgsb"
    git pull --rebase --autostash
}

config_lbfgsb() {
    mkdir -p "$SRCDIR/lbfgsb/build-yorick"
    cd "$SRCDIR/lbfgsb/build-yorick"
    ../yorick/configure yorick="$YORICK_EXE"
}

build_lbfgsb() {
    cd "$SRCDIR/lbfgsb/build-yorick"
    make clean
    make -j4 all
}

install_lbfgsb() {
    cd "$SRCDIR/lbfgsb/build-yorick"
    make install
}
