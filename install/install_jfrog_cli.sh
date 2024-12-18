#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: KhulnaSoft Ltd
#  Date: 2021-12-14 16:44:47 +0000 (Tue, 14 Dec 2021)
#
#  https://github.com/BuildScale/DevOps-Scripts
#
#  License: see accompanying KhulnaSoft Ltd LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/company/khulnasoft
#

# https://jfrog.com/getcli/

# https://www.jfrog.com/confluence/display/CLI/JFrog+CLI

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
#srcdir="$(dirname "${BASH_SOURCE[0]}")"

tmp="$(mktemp -d)"
cd "$tmp"

# both give the same actual binary

# installs as 'jfrog' in ~/bin
#curl -fL https://getcli.jfrog.io | bash -s v2
#mv -iv -- jfrog ~/bin/jfrog

# installs as 'jf' in /usr/local/bin
curl -fL "https://install-cli.jfrog.io" | sh

echo
jf --version

if [ -n "${JFROG_TOKEN:-}" ]; then
    echo
    jf setup "$JFROG_TOKEN"
fi
