#!/usr/bin/env bash

set -o errexit -o pipefail -o nounset


if [[ -z "$POSTGRES_VERSION" ]]; then
  echo "POSTGRES_VERSION must be set"
  exit 1
fi

if [[ "$POSTGRES_VERSION" != @(11|12|13|14) ]]; then
  echo "POSTGRES_VERSION must be one of 11, 12, 13, 14"
  exit 1
fi

# Postgres 14 is not available by default so we need to add the repo
echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update

apt-get install -y postgresql-$POSTGRES_VERSION
