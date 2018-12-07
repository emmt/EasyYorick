#______________________________________________________________________________
#
# STANDARD PACKAGES
#

ypkg_define "yfitsio" "https://github.com/emmt/YFITSIO.git"
ypkg_define "yorxpa" "https://github.com/emmt/YorXPA.git"
ypkg_define "ylib" "https://github.com/emmt/ylib.git"
ypkg_define "ipy" "https://github.com/emmt/IPY.git"
ypkg_define "yoifits" "https://github.com/emmt/YOIFITS.git"
ypkg_define "yandor" "https://github.com/emmt/YAndor.git"
ypkg_define "ydlwrap" "https://github.com/emmt/YDLWrap.git"
ypkg_define "ytotvar" "https://github.com/emmt/YTotVar.git"
ypkg_define "yimage" "https://github.com/emmt/YImage.git"
ypkg_define "yusb" "https://github.com/emmt/yusb.git"
ypkg_define "ysox" "https://github.com/emmt/YSoX.git"
ypkg_define "yunix" "https://github.com/emmt/YUnix.git"

config_ydlwrap() {
    mkdir -p "$SRCDIR/ydlwrap/build"
    cd "$SRCDIR/ydlwrap/build"
    ../configure --yorick="$YORICK_EXE" \
                 --cflags='-DHAVE_FFCALL -DHAVE_LIBTOOL' \
                 --deplibs='-lavcall -lltdl -ldl'
}
