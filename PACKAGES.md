# Conventions for packages

1. A package name consists in ASCII alphanumeric characters and, possibly,
   dashes (minus signs).

2. For each supported package, the command:

   ```sh
   ypkg_define $pkg $url
   ```

   must be called to add the package to the list of available packages and to
   define a global variable with the URL of the original GIT repository.  The
   name of this variable is the package name converted to uppercase letters
   and dashes converted to underscores followed by `_ORIGIN`.

3. The directory where is the local repository of a package is `$SRCDIR/$pkg`
   where `$SRCDIR` is defined by the global configuration and `$pkg` is the
   package name.  The values of the global variables are listed by:

   ```sh
   ypkg variables
   ```

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


# Customization or providing other packages

When `ypkg` is started, each file in `$SCRIPTDIR` is sourced after all package
specific functions have been defined.  This allows for customization of known
packages and addition of new (unknown) packages.

The scripts in `$SCRIPTDIR` are sourced in the lexicographic order so it is
recommended to have names starting by a two digit number between `01` and `98`.
Scripts named `00...` will be sourced first and are reserved for
pre-initialization of `ypkg` while scripts named `99...` will be sourced last
and are reserved for post-initialization.

The values of the global variables, like `$SCRIPTDIR` which can be used
in customization scripts are listed by the command:

```sh
ypkg variables
```


## Customize a known package

To customize a known package, create a shell script in `$SCRIPTDIR` which
overwrite some or all the package specific functions `clone_$pkg`,
`update_$pkg`, `config_$pkg`, `build_$pkg` and `install_$pkg`.  See [Section
*Conventions for packages*](#conventions-for-packages) for a description and
examples of these functions.

For instance, if you want to change the configuration options of `ygsl`, create
a script `$SCRIPTDIR/20ygsl.sh` whose contents is something like:

```sh
config_ygsl() {
    mkdir -p "$SRCDIR/ygsl/build"
    cd "$SRCDIR/ygsl/build"
    ../configure --yorick="$YORICK_EXE" \
        --cflags="-I/usr/local/include" \
        --deplibs="-L/usr/local/lib -lgsl -lgslcblas"
}
```

## Provide a new package

To provide a new package, create a shell script in `$SCRIPTDIR` which follows
the instruction in [Section *Conventions for
packages*](#conventions-for-packages).
