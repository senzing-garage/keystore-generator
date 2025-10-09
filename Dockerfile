# -----------------------------------------------------------------------------
# Stages
# -----------------------------------------------------------------------------

ARG IMAGE_FINAL=debian:13-slim@sha256:1caf1c703c8f7e15dcf2e7769b35000c764e6f50e4d7401c355fb0248f3ddfdb

# -----------------------------------------------------------------------------
# Stage: builder
# -----------------------------------------------------------------------------

FROM ${IMAGE_FINAL} AS builder
ENV REFRESHED_AT=2025-09-01
LABEL Name="senzing/python-builder" \
      Maintainer="support@senzing.com" \
      Version="1.0.0"

# Run as "root" for system installation.

USER root

# Install packages via apt-get.

RUN apt-get update \
 && apt-get -y --no-install-recommends install \
      git \
      python3 \
      python3-dev \
      python3-pip \
      python3-venv \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Create and activate virtual environment.

RUN python3 -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

COPY . /git-repository
WORKDIR /git-repository

# Install packages via PIP.

RUN python3 -m pip install --upgrade pip \
 && python3 -m pip install --requirement requirements.txt \
 && python3 -m pip install build

# -----------------------------------------------------------------------------
# Stage: final
# -----------------------------------------------------------------------------

FROM ${IMAGE_FINAL}

ENV REFRESHED_AT=2022-09-01

LABEL Name="senzing/keystore-generator" \
      Maintainer="support@senzing.com" \
      Version="1.0.0"

# Define health check.

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Run as "root" for system installation.

USER root

# Install packages via apt-get.

RUN apt-get update \
 && apt-get -y --no-install-recommends install \
      apt-transport-https \
      ca-certificates \
      gnupg2 \
      gpg \
      python3 \
      wget \
&& rm -rf /var/lib/apt/lists/*

# Install Java 21.

RUN wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null

RUN echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list

RUN apt-get update \
 && apt-get install -y --no-install-recommends temurin-21-jdk \
 && rm -rf /var/lib/apt/lists/*

# Copy files from repository.

COPY ./rootfs /
COPY ./keystore-generator.py /app/

# Copy files from prior stage.

COPY --from=builder /app/venv /app/venv

# Make non-root container.

USER 1001:1001

# Runtime environment variables.

ENV VIRTUAL_ENV=/app/venv
ENV PATH="/app/venv/bin:${PATH}"

# Runtime execution.

WORKDIR /app
ENTRYPOINT ["/app/keystore-generator.py"]
