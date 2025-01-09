#! /bin/bash

set -ex

epub_filename="$1"

if [ -f "$epub_filename" ]; then
    echo "Usage: bash $0 <epub filename>"
    exit 2
fi

# insert download link on frontpage
# note that we can't use \EOF easily, since we need to embed the filename
cat >> source/index.rst <<\EOF


Download this document
----------------------

`Download as ePub <download/epub_filename>`__
EOF

sed -i "s|epub_filename|$epub_filename|" source/index.rst
