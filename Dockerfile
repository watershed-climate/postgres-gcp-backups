FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:latest
ARG POSTGRES_VERSION

RUN apt-get update && apt-get install -y gzip

WORKDIR /scripts
COPY install-pg-dump.sh .
RUN "/scripts/install-pg-dump.sh"

COPY backup.sh .
ENTRYPOINT [ "/scripts/backup.sh" ]
