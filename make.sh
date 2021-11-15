#! /bin/bash

set -eo pipefail

CUR_DIR="$(readlink -f "$(dirname "$0")")"

cd "$CUR_DIR"

VENV="$CUR_DIR"/.venv

if [ ! -d "$VENV" ] || [ ! -e "$VENV"/bin/activate ]; then
    echo "$(tput bold)$(tput setaf 2)Creating new virtual environment in $VENV$(tput sgr0)"
    python3 -m venv "$VENV"
fi

source "$VENV"/bin/activate

# this snippet should allow us to call pip install only if the requirements file has been touched
if [ ! -f "$VENV"/requirements.txt ] || [ "$(sha256sum requirements.txt | cut -d' ' -f1)" != "$(sha256sum "$VENV"/requirements.txt | cut -d' ' -f1)" ]; then
    echo "$(tput bold)$(tput setaf 2)Requirements updated, reinstalling$(tput sgr0)"
    pip install -U -r requirements.txt

    # we want to make sure the installation works before copying the file
    cp requirements.txt "$VENV"/requirements.txt
fi

make "$@"
