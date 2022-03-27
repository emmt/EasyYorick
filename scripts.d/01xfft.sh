#
# Build and install scripts for XFFT.
#

ypkg_define "xfft" "https://github.com/emmt/XFFT.git"

clone_xfft() {
    if ! test -d "$SRCDIR/xfft"
    then
        cd "$SRCDIR"
        git clone "$XFFT_ORIGIN" xfft
    fi
}

update_xfft() {
    clone_xfft
    cd "$SRCDIR/xfft"
    git pull -r
}

config_xfft() {
    clone_xfft
    mkdir -p "$SRCDIR/xfft/build"
    cd "$SRCDIR/xfft/build"
    ../configure --yorick="$YORICK_EXE"
}

build_xfft() {
    test -f "$SRCDIR/xfft/build/Makefile" || config_xfft
    cd "$SRCDIR/xfft/build"
    make clean
    make all
}

install_xfft() {
    test -f "$SRCDIR/xfft/build/xfft.so" || build_xfft
    cd "$SRCDIR/xfft/build"
    make install
}
