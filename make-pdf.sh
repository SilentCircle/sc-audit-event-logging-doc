#!/bin/sh
ffi="$1"
ffo="$2"
fft=$(mktemp -p . "${1}.XXXXXXXX")
cp -a "$ffi" "$fft"
sh version-doc.sh "$fft"
pandoc -o "$ffo" "$fft"
rm -f "$fft"
