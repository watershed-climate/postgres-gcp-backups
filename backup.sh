#!/bin/bash

set -o errexit -o nounset -o pipefail

auth_gcloud() {
    gcloud config set project watershed-security-and-privacy
    gcloud auth login --cred-file=$GCS_AUTH_KEY_FILE
}

pg_dump_database() {
    # Set statement_timeout to 0 to prevent the dump from timing out
    export PGOPTIONS="-c statement_timeout=0"

    pg_dump --no-owner --no-privileges --clean --if-exists --quote-all-identifiers -n public "$DATABASE_URL"
}

upload_to_bucket() {
    # See https://cloud.google.com/sdk/gcloud/reference/storage/cp
    gcloud storage cp backup.sql.gz "gs://$GCS_BUCKET_NAME/$(date +%Y-%m-%dT%H-%MZ.sql.gz)"
}

main() {
    auth_gcloud

    echo "Taking a backup of Postgres database..."
    pg_dump_database | gzip > backup.sql.gz

    echo "Uploading it to GCS..."
    upload_to_bucket

    echo "Done."
}

main
