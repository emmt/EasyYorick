#
# Build and install scripts for Yeti.
#

ypkg_define "yeti" "https://github.com/emmt/Yeti.git"

clone_yeti() {
    if ! test -d "$SRCDIR/yeti"
    then
        cd "$SRCDIR"
        git clone "$YETI_ORIGIN" yeti
    fi
}

update_yeti() {
    clone_yeti
    cd "$SRCDIR/yeti"
    git pull -r
}

config_yeti() {
    mkdir -p "$SRCDIR/yeti/build"
    cd "$SRCDIR/yeti/build"
    ../configure --yorick="$YORICK_EXE"
}

build_yeti() {
    cd "$SRCDIR/yeti/build"
    make clean
    make -j4 all
}

install_yeti() {
    cd "$SRCDIR/yeti/build"
    make install
}
