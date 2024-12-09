#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: $CIRCLECI_ORGANIZATION_ID testcontext haritest=stuff
#
#  Author: KhulnaSoft Ltd
#  Date: 2021-12-03 17:41:23 +0000 (Fri, 03 Dec 2021)
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
Adds / updates CircleCI context-level environment variable(s) from args or stdin

If no third argument is given, reads environment variables from standard input, one per line in 'key=value' format or 'export key=value' shell format

You'll need your Organization ID which isn't currently exposed by the CircleCI API, so you'd need to get this from the contexts page first:

    https://app.circleci.com/settings/organization/<VCS>/<USER_OR_ORG>/contexts
eg.
    https://app.circleci.com/settings/organization/github/BuildScale/contexts

Examples:

    ${0##*/} \$org_id testcontext AWS_ACCESS_KEY_ID=AKIA...

    export AWS_ACCESS_KEY_ID=AKIA... | ${0##*/} \$org_id testcontext


    Loads both AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY via stdin:

        aws_csv_creds.sh credentials_exported.csv | ${0##*/} \$org_id testcontext
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<organization_id> <context_name> [<key>=<value> <key2>=<value2> ...]"

help_usage "$@"

min_args 2 "$@"

# can't get context listing working because can't figure out owner-id and owner-slug wasn't working
org_id="$1"
context_name="$2"
shift || :
shift || :

# quick pagination support to find the context id from the full list of contexts
while true; do
    page_token=""
    output="$("$srcdir/circleci_api.sh" "/context?owner-id=$org_id&next_page_token=$page_token")"
    context_id="$(jq_debug_pipe_dump <<< "$output" | jq -r ".items[] | select(.name == \"$context_name\") | .id")"
    if [ -n "$context_id" ]; then
        break
    fi
    page_token="$(jq -r .next_page_token <<< "$output")"
    if [ -z "$page_token" ]; then
        break
    fi
done

if [ -z "$context_id" ]; then
    die "Failed to find context with name '$context_name'"
fi

add_env_var(){
    local env_var="$1"
    parse_export_key_value "$env_var"
    # shellcheck disable=SC2154
    timestamp "adding/updating environment variable '$key' to context '$context_id'"
    # shellcheck disable=SC2154
    # XXX: this is a POST at the project level but a PUT at the context level (else 404 error)
    "$srcdir/circleci_api.sh" "/context/$context_id/environment-variable/$key" -X PUT -d "{\"value\": \"$value\"}" | jq .
}


if [ $# -gt 0 ]; then
    for arg in "$@"; do
        add_env_var "$arg"
    done
else
    while read -r line; do
        add_env_var "$line"
    done
fi
