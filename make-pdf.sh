#!/bin/sh
ffi="$1"
ffo="$2"
fft=$(mktemp -p . "${1}.XXXXXXXX")
cp -a "$ffi" "$fft"
ed -s "$fft" >/dev/null <<EOF
2
i
*Version: $(git describe)*

*Date: $(date -u '+%Y-%m-%d')*
.
wq
EOF
pandoc -o "$ffo" "$fft"
rm -f "$fft"
