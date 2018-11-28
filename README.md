# Easy Yorick

This repository provides a script ([ypkg](./ypkg)) to install
[Yorick](https://github.com/dhmunro/yorick) and and some extensions (among
others [MiRA](https://github.com/emmt/MiRA)).


## First installation

To install **EasyYorick** for the first time, you can clone the source
repository or download the sources
[here](https://github.com/emmt/EasyYorick/archive/master.zip).  Whatever the
chosen method to retrieve the sources, to use the software, you will need to
have `git` installed on your system.


### Clone source repository

To clone the source repository with HTTPS, type:

```sh
git clone https://github.com/emmt/EasyYorick.git
```

You may also clone the source repository with SSH as follows:

```sh
git clone git@github.com:emmt/EasyYorick.git
```

Either of these cmmands create a directory `EasyYorick` with the sources.  The
next steps are to [configure and install](#configure-and-install) the software
as explained below.


### Download and extract sources

An alternative to get the sources is to download  the
sources at https://github.com/emmt/EasyYorick/archive/master.zip
and extract the contents of the archive:

```sh
unzip -a EasyYorick-master.zip
```

This creates a directory `EasyYorick-master` with the sources.  The next steps
are to [configure and install](#configure-and-install) the software as
explained below.


### Configure and install

First create a directory to build the software, for instance:

```sh
mkdir -p "$SRCDIR/build"
```

with `$SRCDIR` the directory where are the sources of **EasyYorick**
(presumably `EasyYorick` or `EasyYorick-master` depending how you did retrieve
the sources).

Then move to this directory and call the configuration script:

```sh
cd "$SRCDIR/build"
"$SRCDIR/configure" --prefix="$PREFIX"
```

where `$PREFIX` is the top directory where to install the software.  If this
directory does not yet exist, it will be created during installation.  If
option `--prefix=...` is not specified, the default installation directory will
be `$HOME/easy-yorick`.  There are other options (call the configuration script
with `--help` to list other options).

Finally, installation is done by:

```sh
make install
```

This will create the [directory tree](#directory-tree) for the software.  The
main command is `$PREFIX/bin/ypkg`.  You may add directory `$PREFIX/bin` to
your `PATH` environment variable.


## Install Yorick

The next thing to do is to install Yorick.  If **EasyYorick** software has been
properly installed, this is as simple as:

```sh
ypkg install yorick
```

(replace `ypkg` by `$PREFIX/bin/ypkg` if directory `$PREFIX/bin` has not been
added to your `PATH`).  After installation, yorick executable is available
as `$PREFIX/bin/yorick`.


## Installation of MiRA

### Required Libraries

You must have some required libraries and headers.  Yorick needs the standard C
and mathematical libraries plus the **X11** libraries.  MiRA requires the
**FFTW** and **NFFT** libraries.  On Ubuntu you should just have to do:

```sh
sudo apt-get install libx11-dev libfftw3-dev libnfft3-dev
```

### Customize Installation Script

Edit the script [`install-yorick.sh`](./install-yorick.sh) to match your needs.
In particular you want to choose `SRCDIR` and `PREFIX`.


### Download Code, Compile and Install

All these operations are carried on by the installation script (as you may have
noticed while editing and reading it).  To  run the script:

```sh
sh install-yorick.sh
```

If all is done without failures (check output messages), you should have a
Yorick and a MiRA executable (unless you choose to not install it) in
`$PREFIX/bin/yorick` and `$PREFIX/bin/ymira` with `$PREFIX` the value of the
variable you have set in the installation script.  Note that the Yorick
executable is a symbolic link.

The documentation of MiRA is in `$PREFIX/man/man1`, to read it:

```sh
man "$PREFIX/man/man1/ymira.1.gz"
```


### Directory tree

**EasyYorick** installs software in a directory tree with the following
sub-directories:

- `$PREFIX/bin` for executables;
- `$PREFIX/etc/ypkg` for configuration files;
- `$PREFIX/lib` for compiled libraries;
- `$PREFIX/share/man` for manual pages;
- `$PREFIX/libexec/yorick` for Yorick;
- `$PREFIX/src` for the local repositories of Yorick and its packages;
- `$PREFIX/include` for header files;

where `$PREFIX` is the top-directory defined when `ypkg` was configured and
installed.
