#
# Build and install scripts for YakMessenger.
#

ypkg_define "yak" "https://github.com/emmt/YakMessenger.jl.git"

clone_yak() {
    if ! test -d "$SRCDIR/yak"
    then
        cd "$SRCDIR"
        git clone "$YAK_ORIGIN" "yak"
    fi
}

update_yak() {
    clone_yak
    cd "$SRCDIR/yak"
    git pull -r
}

config_yak() {
    test -d "$SRCDIR/yak" || clone_yak
    test -d "$SRCDIR/yak/yorick" || update_yak
}

build_yak() {
    test -d "$SRCDIR/yak/yorick" || config_yak
}

install_yak() {
    local dir
    dir="$SRCDIR/yak/yorick"
    test -d "$dir" || build_yak
    cp -a "$dir/yak.i" "$Y_SITE/i0/yak.i"
    cp -a "$dir/yak-start.i" "$Y_SITE/i-start/yak-start.i"
}
