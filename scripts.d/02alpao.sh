#______________________________________________________________________________
#
# Build and install YAlpao.
#
# Dependencies:
#
#     sudo apt install libgsl
#

ypkg_define "yalpao" "https://github.com/emmt/yalpao.git"

clone_yalpao() {
    if ! test -d "$SRCDIR/yalpao"
    then
        cd "$SRCDIR"
        git clone "$YALPAO_ORIGIN" yalpao
    fi
}

update_yalpao() {
    clone_yalpao
    cd "$SRCDIR/yalpao"
    git pull -r
}

config_yalpao() {
    local cflags deplibs
    clone_yalpao
    mkdir -p "$SRCDIR/yalpao/build"
    cd "$SRCDIR/yalpao/build"
    if test "$ALPAO_DIR" != ""; then
        cflags="-I$ALPAO_DIR/include"
        deplibs="-L$ALPAO_DIR/lib64 -lasdk"
    else
        cflags="-I/apps/libexec/alpao/include"
        deplibs="-L/apps/libexec/alpao/lib64 -lasdk"
    fi
    ../configure --yorick="$YORICK_EXE" --cflags="$cflags" --deplibs="$deplibs"
}

build_yalpao() {
    test -f "$SRCDIR/yalpao/build/Makefile" || config_yalpao
    cd "$SRCDIR/yalpao/build"
    make clean
    make all
}

install_yalpao() {
    test -f "$SRCDIR/yalpao/build/yalpao.so" || build_yalpao
    cd "$SRCDIR/yalpao/build"
    make install
}
