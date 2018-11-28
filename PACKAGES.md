# CONVENTIONS FOR PACKAGES

1. A package name consists in ASCII alphanumeric characters and, possibly,
   dashes (minus signs).

2. For each supported package, the command:

   ```sh
   ypkg_define $pkg $url
   ```

   must be called to add the package to the list of available packages and to
   define a global variable with the URL of the original GIT repository.  The
   name of this variable is the package name converted to uppercase letters
   and dashes converted to underscores followed by `_GIT`.

3. The directory where is the local repository of a package is `$SRCDIR/$pkg`
   where `$SRCDIR` is given by the global configuration and `$pkg` is the
   package name.

4. For each supported package, a number of functions can be defined:

   ```
   clone_$pkg()    to initially clone the package repository
   update_$pkg()   to update the local package repository
   config_$pkg()   to configure the package before building
   build_$pkg()    to build the package
   install_$pkg()  to install the package
   ```

   where `$pkg` is the package name (in lower case letters and with dashes
   replaced by underscores).   If a specific function is not defined, a
   default fallback is called instead.  The fallbacks are equivalent to the
   following definitions:

   ```sh
   clone_$pkg() {
       local url
       cd "$SRCDIR"
       url=`ypkg_origin "$pkg"`
       git clone "$url" "$pkg"
   }

   update_$pkg() {
       cd "$SRCDIR/$pkg"
       git pull
   }

   config_$pkg() {
       mkdir -p "$SRCDIR/$pkg/build"
       cd "$SRCDIR/$pkg/build"
       ../configure --yorick="$YORICK_EXE"
   }

   build_$pkg() {
       cd "$SRCDIR/$pkg/build"
       make clean
       make all
   }

   install_$pkg() {
       cd "$SRCDIR/$pkg/build"
       make install
   }
   ```

   Here `ypkg_origin $pkg` yields the URL of the remote GIT repository of
   package `$pkg` and `$YORICK_EXE` is a global variable with the full path to
   Yorick executable.
