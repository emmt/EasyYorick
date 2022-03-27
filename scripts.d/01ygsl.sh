#
# Build and install scripts for YGSL a Yorick plug-in for the GNU Scientific
# Library.
#
# Dependencies:
#
#     sudo apt install libgsl
#

ypkg_define "ygsl" "https://github.com/emmt/ygsl.git"

clone_ygsl() {
    if ! test -d "$SRCDIR/ygsl"
    then
        cd "$SRCDIR"
        git clone "$YGSL_ORIGIN" ygsl
    fi
}

update_ygsl() {
    clone_ygsl
    cd "$SRCDIR/ygsl"
    git pull -r
}

config_ygsl() {
    mkdir -p "$SRCDIR/ygsl/build"
    cd "$SRCDIR/ygsl/build"
    ../configure --yorick="$YORICK_EXE"
}

build_ygsl() {
    test -f "$SRCDIR/ygsl/build/Makefile" || config_ygsl
    cd "$SRCDIR/ygsl/build"
    make clean
    make all
}

install_ygsl() {
    test -f "$SRCDIR/ygsl/build/ygsl.so" || build_ygsl
    cd "$SRCDIR/ygsl/build"
    make install
}
