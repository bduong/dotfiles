#!/bin/bash

PWD=$(pwd)
NANORC="nanorc"

rcs=(
    "apacheconf"
    "asm"
    "cmake"
    "c"
    "conf"
    "css"
#   "cython"
    "fortran"
    "gentoo"
    "groff"
    "haml"
    "html"
    "java"
    "js"
    "lua"
    "man"
    "mutt"
    "nanorc"
    "patch"
    "perl"
    "php"
    "pov"
    "python"
    "reST"	
    "ruby"
    "sh"	
    "tex"
    "xml"
#	"zshrc"
)

echo -n > $NANORC

for rc in ${rcs[@]}; do   
    echo "include \"$PWD/$rc.nanorc\"" >> $NANORC
done
