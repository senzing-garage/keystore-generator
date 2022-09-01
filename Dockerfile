ARG BASE_IMAGE=debian:11.4-slim@sha256:68c1f6bae105595d2ebec1589d9d476ba2939fdb11eaba1daec4ea826635ce75
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2022-09-01

LABEL Name="senzing/keystore-generator" \
      Maintainer="support@senzing.com" \
      Version="1.0.0"

# Define health check.

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Run as "root" for system installation.

USER root

# Install packages via apt.

RUN apt-get update \
 && apt-get -y install \
      gnupg2 \
      python3 \
      python3-pip \
      software-properties-common \
      wget \
 && rm -rf /var/lib/apt/lists/*

# Install packages via PIP.

COPY requirements.txt .
RUN pip3 install --upgrade pip \
 && pip3 install -r requirements.txt \
 && rm /requirements.txt

# Install Java 11

RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public > gpg.key \
 && cat gpg.key | apt-key add - \
 && add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ \
 && apt update \
 && apt install -y adoptopenjdk-11-hotspot \
 && rm -rf /var/lib/apt/lists/* \
 && rm -f gpg.key

# Copy files from repository.

COPY ./rootfs /
COPY ./keystore-generator.py /app/

# Make non-root container.

USER 1001:1001

# Runtime execution.

WORKDIR /app
ENTRYPOINT ["/app/keystore-generator.py"]
