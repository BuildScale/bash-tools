#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: KhulnaSoft Ltd
#  Date: 2024-10-08 02:32:00 +0300 (Tue, 08 Oct 2024)
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
Installs Prometheus
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<version> <component_name>]"

export PATH="$PATH:$HOME/bin"

help_usage "$@"

#version="${1:-2.54.1}"
version="${1:-latest}"
name="${2:-prometheus}"

export RUN_VERSION_OPT=1

"$srcdir/../github/github_install_binary.sh" prometheus/"$name" "$name-{version}.{os}-{arch}.tar.gz" "$version" "$name-{version}.{os}-{arch}/$name"
