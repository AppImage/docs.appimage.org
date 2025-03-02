#! /bin/bash

set -eo pipefail

if ! which -s poetry; then
    echo "Error: this script requires poetry"
    echo "Please install poetry, e.g., using:"
    echo "  > apt-get install python3-poetry"
    echo "  > pipx install poetry"
    exit 2
fi

CUR_DIR="$(readlink -f "$(dirname "$0")")"

cd "$CUR_DIR"

poetry install

poetry run make "$@"
