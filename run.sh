#!/bin/bash
# run.sh for Chrysalis-Firmware-Bundle
#
# Copyright (c) 2022 Christopher White (https://github.com/cxw42).
# Copying and distribution of this file, with or without modification, are
# permitted in any medium without royalty provided the copyright notice and
# this notice are preserved. This file is offered as-is, without any warranty.
# SPDX-License-Identifier: FSFAP
#
# Details at <https://devwrench.wordpress.com/2022/10/21/keyboardio-model100-custom-firmware-notes/>

set -euo pipefail

# === Globals ===============================================================

gHere="$(cd "$(dirname "$0")" ; pwd)"
gVerbose=

# === main ==================================================================

main() {
    local -r cmd="${1:-make}"

    KALEIDOSCOPE_DIR="$(realpath "$gHere/.kaleidoscope/")"
    ARDUINO_DIRECTORIES_USER="$(realpath "$gHere/.kaleidoscope/.arduino/user")"
    export KALEIDOSCOPE_DIR ARDUINO_DIRECTORIES_USER

    case "$cmd" in
        setup)  RUN make -C "$KALEIDOSCOPE_DIR" setup ;;
        make)   RUN make Keyboardio/Model100 VERBOSE=1  ;;
        flash)  RUN ~/src/dfu-util/src/dfu-util -d 3496:0005 -D ./output/Keyboardio/Model100/default.bin -R ;;
        *) die "Unknown command [$cmd]" ;;
    esac

    return 0
}

# === Utilities =============================================================

# Run a program, printing the command line first if verbose.
RUN() {
    if (( gVerbose )); then
        printf '%s ' "$@" 1>&2
        echo 1>&2
    fi

    "$@"
    return "$?"
}

# die ['2'] <message>... - print <message> to stderr, then exit.
# The exit code is 1 unless $1 = '2', in which case the exit code is 2.
die() {
    local exitval=1
    if [[ "${1:-}" = '2' ]]; then
        exitval=2
        shift
    fi

    printf '%s ' "Error:" "$@" \
        "(at ${BASH_SOURCE[0]}:${BASH_LINENO[0]})" 1>&2
    echo 1>&2
    exit "$exitval"
} # die()

# === Do it, Rockapella! ====================================================
main "$@"
exit "$?"

# vi: set ts=4 sts=4 sw=4 et ai: #
