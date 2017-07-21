#!/bin/sh
ed -s "$1" >/dev/null <<EOF
2
i

*Version: $(git describe)*

*Date: $(date -u '+%Y-%m-%d')*
.
wq
EOF
