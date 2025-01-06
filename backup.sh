#!/bin/bash

set -o errexit -o nounset -o pipefail

# From https://blog.sentry.io/sentry-bash/
eval "$(sentry-cli bash-hook)"

filename="$(date +%Y-%m-%dT%H-%MZ.sql.gz)"

echo "Backing up Postgres database into GCS file $filename..."

gcloud auth activate-service-account --key-file=$GCS_AUTH_KEY_FILE \
  --project=watershed-security-and-privacy

# Set statement_timeout to 0 to prevent the dump from timing out
export PGOPTIONS="-c statement_timeout=0"

pg_dump --no-owner --no-privileges --quote-all-identifiers \
  "$DATABASE_URL" \
  | gzip \
  | gcloud storage cp - "gs://$GCS_BUCKET_NAME/$filename"

echo "Done."
