#
# Build and install scripts for YOR-VOPS.
#

ypkg_define "yor-vops" "https://github.com/emmt/yor-vops.git"

if test "x$YOR_VOPS_CC" = "x"; then
    YOR_VOPS_CC=clang
fi
if test "x$YOR_VOPS_COPT" = "x"; then
    YOR_VOPS_COPT="-O3 -mavx2 -mfma -ffast-math"
fi

clone_yor_vops() {
    if ! test -d "$SRCDIR/yor-vops"
    then
        cd "$SRCDIR"
        git clone "$YOR_VOPS_ORIGIN" yor-vops
    fi
}

update_yor_vops() {
    clone_yor_vops
    cd "$SRCDIR/yor-vops"
    git pull --rebase --autostash
}

config_yor_vops() {
    mkdir -p "$SRCDIR/yor-vops/build"
    cd "$SRCDIR/yor-vops/build"
    ../configure yorick="$YORICK_EXE" cc="$YOR_VOPS_CC" copt="$YOR_VOPS_COPT"
}

build_yor_vops() {
    cd "$SRCDIR/yor-vops/build"
    make clean
    make -j4 all
}

install_yor_vops() {
    cd "$SRCDIR/yor-vops/build"
    make install
}
