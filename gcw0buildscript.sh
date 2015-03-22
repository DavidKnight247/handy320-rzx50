#! /bin/sh

make;
mv handy320 build/;
mksquashfs build/ handy.opk -all-root -noappend -no-exports -no-xattrs;

