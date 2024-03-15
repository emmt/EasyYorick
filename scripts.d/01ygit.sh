#
# Build and install scripts for YGit.
#

ypkg_define "ygit" \
            "https://github.com/emmt/ygit.git"

clone_ygit() {
    if ! test -d "$SRCDIR/ygit"
    then
        cd "$SRCDIR"
        git clone "$YGIT_ORIGIN" ygit
    fi
}

update_ygit() {
    clone_ygit
    cd "$SRCDIR/ygit"
    git pull -r
}

config_ygit() {
    local dir
    dir="$SRCDIR/ygit/build"
    mkdir -p "$dir"
    cd "$dir"
    ../configure --yorick="$YORICK_EXE"
}

build_ygit() {
    local dir
    dir="$SRCDIR/ygit/build"
    test -f "$dir/Makefile" || config_ygit
    cd "$dir"
    make clean
    make -j4 all
}

install_ygit() {
    local dir
    dir="$SRCDIR/ygit/build"
    test -f "$dir/ygit.so" || build_ygit
    cd "$dir"
    make install
}
