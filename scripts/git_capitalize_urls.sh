#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: KhulnaSoft Ltd
#  Date: 2022-04-28 19:22:01 +0100 (Thu, 28 Apr 2022)
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
Replaces URLs in git files with capitalized equivalents for uniformity and easier reading
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

sed_script="
s|https\\?://www.linkedin.com/company/khulnasoft|https://www.linkedin.com/company/khulnasoft|gi;
s|https\\?://ghcr.io/buildscale/|https://ghcr.io/BuildScale/|gi;

$(
    sed 's/#.*//; /^[[:space:]]*$/d; s/:/ /' "$srcdir/../setup/repos.txt" |
    while read -r repo shortname; do
        if [ -n "$repo" ]; then
            echo "s|https\\?://github.com/buildscale/$repo|https://github.com/BuildScale/$repo|gi;"
        fi
        if [ -n "$shortname" ]; then
            echo "s|https\\?://github.com/buildscale/$shortname$|https://github.com/BuildScale/$repo|gi;"
            echo "s|https\\?://github.com/buildscale/$shortname/|https://github.com/BuildScale/$repo/|gi;"
        fi
        echo
    done
)"

echo "Running sed script on all Git files:"
echo
echo "$sed_script"
echo

for filename in $(git ls-files); do
    [ -f "$filename" ] || continue
    [ -d "$filename" ] && continue
    [ -L "$filename" ] && continue
    echo "$filename"
done |
if is_mac; then
    xargs gsed -i "$sed_script"
else
    xargs sed -i "$sed_script"
fi
