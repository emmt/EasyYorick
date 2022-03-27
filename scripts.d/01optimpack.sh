#
# Build and install scripts for OptimPack.
#

ypkg_define "optimpack" \
            "https://github.com/emmt/OptimPack.git"

clone_optimpack() {
    if ! test -d "$SRCDIR/optimpack"
    then
        cd "$SRCDIR"
        git clone "$OPTIMPACK_ORIGIN" optimpack
    fi
}

update_optimpack() {
    clone_optimpack
    cd "$SRCDIR/optimpack"
    git pull -r
}

config_optimpack() {
    local dir
    dir="$SRCDIR/optimpack/yorick/build"
    mkdir -p "$dir"
    cd "$dir"
    ../configure --yorick="$YORICK_EXE"
}

build_optimpack() {
    local dir
    dir="$SRCDIR/optimpack/yorick/build"
    test -f "$dir/Makefile" || config_optimpack
    cd "$dir"
    make clean
    make -j4 all
}

install_optimpack() {
    local dir
    dir="$SRCDIR/optimpack/yorick/build"
    test -f "$dir/opky.so" || build_optimpack
    cd "$dir"
    make install
}
