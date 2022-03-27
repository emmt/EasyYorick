#
# Build and install scripts for VMLMB.
#
# Dependencies:
#
#     ypkg install yorick yeti optimpacklegacy ylib ipy yoifits
#

ypkg_define "vmlmb" "https://github.com/emmt/VMLMB.git"

clone_vmlmb() {
    if ! test -d "$SRCDIR/vmlmb"
    then
        cd "$SRCDIR"
        git clone "$VMLMB_ORIGIN" vmlmb
    fi
}

update_vmlmb() {
    test -e "$SRCDIR/vmlmb" || clone_vmlmb
    cd "$SRCDIR/vmlmb"
    git pull -r
}

config_vmlmb() {
    # Call `ypkg_install` to install required packages.
    ypkg_install yorick yeti
    test -e "$SRCDIR/vmlmb" || clone_vmlmb
    cd "$SRCDIR/vmlmb/yorick"
    ./configure --yorick="$YORICK_EXE"
}

build_vmlmb() {
    test -f "$SRCDIR/vmlmb/yorick/Makefile" || config_vmlmb
    cd "$SRCDIR/vmlmb/yorick"
    make clean
    make
}

install_vmlmb() {
    test -f "$SRCDIR/vmlmb/yorick/Makefile" || config_vmlmb
    cd "$SRCDIR/vmlmb/yorick"
    make install
}
