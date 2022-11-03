# Easy Yorick

This repository provides a script ([ypkg](./ypkg)) to install
[Yorick](https://github.com/LLNL/yorick) and and some extensions (among
others [MiRA](https://github.com/emmt/MiRA)).


## First installation

To install **EasyYorick** for the first time, you have to clone the source
repository or to download the sources
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

Either of these commands create a directory `EasyYorick` with the sources.  The
next steps are to [configure and install](#configure-and-install) the software.


### Download and extract sources

An alternative to get the sources is to download  the
sources at https://github.com/emmt/EasyYorick/archive/master.zip
and extract the contents of the archive:

```sh
unzip -a EasyYorick-master.zip
```

This creates a directory `EasyYorick-master` with the sources.  The next steps
are to [configure and install](#configure-and-install) the software.


### Configure and install

Configuration can be done from anywhere (it just creates a file `Makefile`
with commands and settings to install the software).  The easier is to
configure and install from the source directory as explanied below.

Move to the source directory and call the configuration script:

```sh
cd "$SRCDIR"
./configure --prefix="$PREFIX"
```

where `$SRCDIR` the directory where are the sources of **EasyYorick**
(presumably `EasyYorick` or `EasyYorick-master` depending how you did retrieve
the sources) and where `$PREFIX` is the top directory where to install the
software.  If this directory does not yet exist, it will be created during
installation.  If option `--prefix=...` is not specified, the default
installation directory will be `$HOME/easy-yorick`.  There are other options
(call the configuration script with `--help` to list them).

Finally, installation is done by:

```sh
make install
```

This will create the [directory tree](#directory-tree) for the software.  The
main command is `$PREFIX/bin/ypkg`.  You may add directory `$PREFIX/bin` to
your `PATH` environment variable.


## Install Yorick

The next thing to do is to install Yorick.  Yorick needs the standard C and
mathematical libraries plus the **X11** libraries.  On Ubuntu you should just
have to do:

```sh
sudo apt-get install libx11-dev
```

If **EasyYorick** software has been properly installed and provided you have
the required X11 libraries and development files, installing Yorick should be
as simple as:

```sh
ypkg install yorick
```

(replace `ypkg` by `$PREFIX/bin/ypkg` if directory `$PREFIX/bin` has not been
added to your `PATH`).  After installation, yorick executable is available
as `$PREFIX/bin/yorick`.


## Usage

The `ypkg` command is used to manage Yorick packages.  Its syntax is:

```sh
ypkg $COMMAND [$OPTION ...] [--] [$PKG ...]
```

where `$COMMAND` is the command to execute, `$OPTION` some optional flag(s) and
`$PKG` a package name (most commands take one or more package names).  Above,
square brackets indicate optional arguments.

The following high level commands are available:

- `ypkg help`

  Print a short help.

- `ypkg list [--]`

  List available packages and their status.  Possible status are:
  - **unknown** if package is not in the database of known packages;
  - **available** if package is available but not installed;
  - **cloned** if repository of package has been cloned;
  - **configured** if package has been configured;
  - **built** if package has been built;
  - **installed** if package has been installed;
  - **upgradable** if package has been installed but a new version is
    in the local repository;
  - **dirty** if local package repository exists but is not a valid
    GIT repository;

- `ypkg check [--] [PKG ...]`

  Check status of package(s).  If no package names are specified, all available
  packages are considered (like the `list` command).

- `ypkg install [--] PKG [...]`

  Install package(s).  Installing a package automatically performs low level
  operations `clone` (if there is no local package repository), `config` (if
  package has not yet been configured) and `build` (if package has not yet been
  built).

- `ypkg reinstall [--] PKG [...]`

  Re-install package(s).  Like `install` but perform every operations `config`,
  `build` and `install` whatever the current package status.

- `ypkg update [--] [PKG ...]`

  Update local repositories of packages to the master remote version.  If no
  packages are specified, all local repositories are updated.  If packages are
  specified, their local repositories must exist (that is, they must have been
  previously installed or, at least, cloned).

- `ypkg upgrade [--] [PKG ...]`

  Upgrade packages.  If no packages are specified, all upgradable packages (the
  ones which are currently installed but whose local repository has changed)
  are re-built and re-installed.  For each specified package, the local
  repository is updated, then the package is re-built and re-installed if the
  local repository has changed.


Low-level commands are:

- `ypkg clone [--] PKG [...]`

  Clone repository of package(s) into a local directory.  Nothing is done if
  local repository alraedy exists.

- `ypkg configure [--] PKG [...]` or `ypkg config [--] PKG [...]`

  Configure package(s) for building.  This operation should be done after
  "clone" or "opdate".

- `ypkg build [--] PKG [...]`

  Build package(s).  This operation should be done after "config".

- `ypkg register [--] [PKG ...]`

  Register package(s) assumed they have been installed.  Useful for packages
  that have been installed by hand.

- `ypkg forget [--] [PKG ...]`

  Forget (that is, un-register) package(s).


## Customization

EasyYorick has a simple plug-in system to extend its knowledge database to
other packages than the ones included in the repository.  Adding a new package
is easy: just add a script in the `scripts.d` directory created in
`$PREFIX/etc/ypkg` during installation.  You can start with an existing script
such as [`scripts.d/01ygsl.sh`](./scrips.d/01ygsl.sh) which is to install a
Yorick plug-in for the *GNU Scientific Library* (GSL).  The [`ypkg`](./ypkg)
script itself can be a source of inspiration.  The scripts in this directory
are sourced by `ypkg` in the lexicographic order of their names.

Fill free to issue a *Pull Request* (PR) to add your script to the EasyYorick
repository.


## Directory tree

**EasyYorick** installs software in a directory tree with the following
sub-directories:

- `$PREFIX/bin` for executables;
- `$PREFIX/etc/ypkg` for configuration files;
- `$PREFIX/lib` for compiled libraries;
- `$PREFIX/share/man` for manual pages;
- `$PREFIX/libexec/yorick` for Yorick files;
- `$PREFIX/src` for the local repositories of Yorick and its packages;
- `$PREFIX/include` for header files;

where `$PREFIX` is the top-directory defined when `ypkg` was configured and
installed.
