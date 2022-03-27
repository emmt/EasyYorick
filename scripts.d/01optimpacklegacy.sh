#
# Build and install scripts for OptimPackLegacy.
#

ypkg_define "optimpacklegacy" \
            "https://github.com/emmt/OptimPackLegacy.git"

clone_optimpacklegacy() {
    if ! test -d "$SRCDIR/optimpacklegacy"
    then
        cd "$SRCDIR"
        git clone "$OPTIMPACKLEGACY_ORIGIN" optimpacklegacy
    fi
}

update_optimpacklegacy() {
    clone_optimpacklegacy
    cd "$SRCDIR/optimpacklegacy"
    git pull -r
}

config_optimpacklegacy() {
    local dir
    dir="$SRCDIR/optimpacklegacy/yorick/build"
    mkdir -p "$dir"
    cd "$dir"
    ../configure --yorick="$YORICK_EXE"
}

build_optimpacklegacy() {
    local dir
    dir="$SRCDIR/optimpacklegacy/yorick/build"
    test -f "$dir/Makefile" || config_optimpacklegacy
    cd "$dir"
    make clean
    make -j4 all
}

install_optimpacklegacy() {
    local dir
    dir="$SRCDIR/optimpacklegacy/yorick/build"
    test -f "$dir/optimpacklegacy.so" || build_optimpacklegacy
    cd "$dir"
    make install
}
