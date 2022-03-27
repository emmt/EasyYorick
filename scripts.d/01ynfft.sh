#
# Build and install scripts for YNFFT a Yorick plug-in for the Nonequispaced
# Fast Fourier Transform.
#
# To install nfft libraries:
#
#     sudo apt-get install libfftw3-dev libnfft3-dev
#

ypkg_define "ynfft" "https://github.com/emmt/ynfft.git"

clone_ynfft() {
    if ! test -d "$SRCDIR/ynfft"
    then
        cd "$SRCDIR"
        git clone "$YNFFT_ORIGIN" ynfft
    fi
}

update_ynfft() {
    clone_ynfft
    cd "$SRCDIR/ynfft"
    git pull -r
}

config_ynfft() {
    mkdir -p "$SRCDIR/ynfft/build"
    cd "$SRCDIR/ynfft/build"
    ../configure --yorick="$YORICK_EXE"
}

build_ynfft() {
    local dir
    dir="$SRCDIR/ynfft/build"
    test -f "$dir/Makefile" || config_ynfft
    cd "$dir"
    make clean
    make all
}

install_ynfft() {
    local dir
    dir="$SRCDIR/ynfft/build"
    test -f "$dir/yor_nfft.so" || build_ynfft
    cd "$dir"
    make install
}
