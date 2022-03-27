#
# Build and install scripts for Yorick-z.
#
# Dependencies:
#
#     sudo apt install zlib1g-dev libpng-dev libjpeg-dev
#

ypkg_define "yorick-z" "https://github.com/dhmunro/yorick-z.git"

clone_yorick_z() {
    if ! test -d "$SRCDIR/yorick-z"
    then
        cd "$SRCDIR"
        git clone "$YORICK_Z_ORIGIN" yorick-z
    fi
}

# We want to keep the source tree as clean as possible (for git) so we
# rename Makefile as Makefile.cfg after configuration.

update_yorick_z() {
    clone_yorick_z
    cd "$SRCDIR/yorick-z"
    rm -f Makefile
    git checkout Makefile
    git pull -r
}

config_yorick_z() {
    clone_yorick_z
    cd "$SRCDIR/yorick-z"
    ./configure --yorick="$YORICK_EXE" --no-avcodec
    mv -f Makefile Makefile.cfg
    git checkout Makefile
}

build_yorick_z() {
    test -f "$SRCDIR/yorick-z/Makefile.cfg" || config_yorick_z
    cd "$SRCDIR/yorick-z"
    make -f Makefile.cfg clean
    make -f Makefile.cfg all
}

install_yorick_z() {
    test -f "$SRCDIR/yorick-z/yorz.so" || build_yorick_z
    cd "$SRCDIR/yorick-z"
    make -f Makefile.cfg install
}
