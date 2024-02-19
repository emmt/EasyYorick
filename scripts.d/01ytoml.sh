#
# Build and install scripts for YTOML.
#

ypkg_define "ytoml" \
            "https://github.com/emmt/ytoml.git"

clone_ytoml() {
    if ! test -d "$SRCDIR/ytoml"
    then
        cd "$SRCDIR"
        git clone "$YTOML_ORIGIN" ytoml
    fi
}

update_ytoml() {
    clone_ytoml
    cd "$SRCDIR/ytoml"
    git pull -r
}

config_ytoml() {
    local dir
    dir="$SRCDIR/ytoml/build"
    mkdir -p "$dir"
    cd "$dir"
    ../configure --yorick="$YORICK_EXE"
}

build_ytoml() {
    local dir
    dir="$SRCDIR/ytoml/build"
    test -f "$dir/Makefile" || config_ytoml
    cd "$dir"
    make clean
    make -j4 all
}

install_ytoml() {
    local dir
    dir="$SRCDIR/ytoml/build"
    test -f "$dir/ytoml.so" || build_ytoml
    cd "$dir"
    make install
}
