#!/usr/bin/env bash

set -e
set -o pipefail
set -v

curl -s -X POST https://stg-api.stackbit.com/project/5eba3d73e9a24f0012f03b05/webhook/build/pull > /dev/null
if [[ -z "${STACKBIT_API_KEY}" ]]; then
    echo "WARNING: No STACKBIT_API_KEY environment variable set, skipping stackbit-pull"
else
    npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://stg-api.stackbit.com/pull/5eba3d73e9a24f0012f03b05 
fi
curl -s -X POST https://stg-api.stackbit.com/project/5eba3d73e9a24f0012f03b05/webhook/build/ssgbuild > /dev/null
gatsby build
./inject-netlify-identity-widget.js public
curl -s -X POST https://stg-api.stackbit.com/project/5eba3d73e9a24f0012f03b05/webhook/build/publish > /dev/null
