#
# Build and install scripts for YakMessenger.
#

ypkg_define "yak" "https://github.com/emmt/YakMessenger.jl.git"

clone_yak() {
    if ! test -d "$SRCDIR/YakMessenger.jl"
    then
        cd "$SRCDIR"
        git clone "$YGIT_ORIGIN" "YakMessenger.jl"
    fi
}

update_yak() {
    clone_yak
    cd "$SRCDIR/YakMessenger.jl"
    git pull -r
}

config_yak() {
    test -d "$SRCDIR/YakMessenger.jl" || clone_yak
    test -d "$SRCDIR/YakMessenger.jl/yorick" || update_yak
}

build_yak() {
    test -d "$SRCDIR/YakMessenger.jl/yorick" || config_yak
}

install_yak() {
    local dir
    dir="$SRCDIR/YakMessenger.jl/yorick"
    test -d "$dir" || build_yak
    cp -a "$dir/yak.i" "$Y_SITE/i0/yak.i"
    cp -a "$dit/yak-start.i" "$Y_SITE/i-start/yak-start.i"
}
