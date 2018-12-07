# YPKG script for YLapack
#
# sudo apt install libopenblas-dev
ypkg_define "ylapack" "https://github.com/emmt/YLapack.git"

config_ylapack() {
    mkdir -p "$SRCDIR/ylapack/build"
    cd "$SRCDIR/ylapack/build"
    ../configure --yorick="$YORICK_EXE" --interface=openblas
}
