#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: KhulnaSoft Ltd
#  Date: 2023-05-23 23:29:32 +0100 (Tue, 23 May 2023)
#
#  https://github.com/BuildScale/DevOps-Scripts
#
#  License: see accompanying KhulnaSoft Ltd LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/company/khulnasoft
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/../lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Installs Kubevious CLI
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<version>]"

export PATH="$PATH:$HOME/bin"

help_usage "$@"

#version="${1:-v1.0.55}"
version="${1:-latest}"

export ARCH_X86_64=x64
export OS_DARWIN=macos
# has a different binary for Alpine - probably due to compilation against musl instead of glibc
if [ -f /etc/alpine-release ]; then
    export OS_LINUX=alpine
fi

export RUN_VERSION_OPT=1

"$srcdir/../github/github_install_binary.sh" kubevious/cli "kubevious-{os}-{arch}" "$version"
