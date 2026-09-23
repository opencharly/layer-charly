#!/usr/bin/env bash
# test-depends.sh — the layer-charly-LOCAL gate for the nerdctl engine stack. It
# FAILS if the four deps (nerdctl + cni-plugins + rootlesskit + buildkit) are
# missing from this repo's charly.yml `formats.archlinux.depends`. Run:
# `bash test-depends.sh`.
set -euo pipefail

cfg="$(dirname "$0")/charly.yml"
rc=0
for p in nerdctl cni-plugins rootlesskit buildkit; do
    if grep -qE "^\s*-\s*${p}\s*$" "$cfg"; then
        echo "ok   archlinux.depends: ${p}"
    else
        echo "FAIL archlinux.depends: ${p} missing from charly.yml" >&2
        rc=1
    fi
done
exit "$rc"
