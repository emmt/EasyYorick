# Easy Yorick

This repository provides a script to install [Yorick]() and  and some
extensions (among others [MiRA](https://github.com/emmt/MiRA).

## Installation

### Required Libraries

Install required libraries and headers.  Yorick needs the standard C and
mathematical libraries plus the X11 libraries.  MiRA requires the FFTW and NFFT
libraries.  On Ubuntu you should just have to do:

```sh
sudo apt-get install libx11-dev libfftw3-dev libnfft3-dev
```


### Customize Installation Script

Edit the script `install-yorick.sh` to match your needs.  In particular you
want to choose `SRCDIR` and `PREFIX`.


### Download Code, Compile and Install

All these operations are carry on by the installation script (as you may have
noticed while editing and reading it).  To  run the script:

```sh
sh install-yorick.sh
```

If all is done without failures (check output messages), you should have
a Yorick and a MiRA executable (unless you choose to not install it) in
`$PREFIX/bin` with `$PREFIX` the value of the variable you have set in
the installation script.

The documentaion of MiRA is in `$PREFIX/man/man1`, to read it:

```sh
man "$PREFIX/man/man1/ymira.1"
```
