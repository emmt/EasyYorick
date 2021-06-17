#
# Build and install scripts for VOPS.
#

ypkg_define "vops" "https://github.com/emmt/yor-vops.git"

if test "x$YOR_VOPS_CC" = "x"; then
    YOR_VOPS_CC=clang
fi
if test "x$YOR_VOPS_COPT" = "x"; then
    YOR_VOPS_COPT="-O3 -mavx2 -mfma -ffast-math"
fi

clone_vops() {
    if ! test -d "$SRCDIR/yor-vops"
    then
        cd "$SRCDIR"
        git clone "$VOPS_ORIGIN" vops
    fi
}

update_vops() {
    clone_vops
    cd "$SRCDIR/yor-vops"
    git pull
}

config_vops() {
    mkdir -p "$SRCDIR/yor-vops/build"
    cd "$SRCDIR/yor-vops/build"
    ../configure yorick="$YORICK_EXE" cc="$YOR_VOPS_CC" clang copt="$YOR_VOPS_COPT"
}

build_vops() {
    cd "$SRCDIR/yor-vops/build"
    make clean
    make -j4 all
}

install_vops() {
    cd "$SRCDIR/yor-vops/build"
    make install
}