#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: KhulnaSoft Ltd
#  Date: 2022-06-28 19:27:21 +0100 (Tue, 28 Jun 2022)
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
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists Jenkins credentials in the given credential store using jenkins_cli.sh

Defaults to the system::system::jenkins global in-built store

Tested on Jenkins 2.319 with Credentials plugin 2.5

Uses adjacent jenkins_cli.sh - see there for more details on required connection settings / environment variables
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

#min_args 1 "$@"

store="${1:-system::system::jenkins}"

# 'export JENKINS_CLI_ARGS=-webSocket' is needed if Jenkins is behind a reverse proxy such as Kubernetes Ingress, otherwise Jenkins CLI hangs
"$srcdir/jenkins_cli.sh" list-credentials "$store"
