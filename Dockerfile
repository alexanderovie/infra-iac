# Multi-stage build for Terraform with 1Password CLI
FROM hashicorp/terraform:1.9.5@sha256:4b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b as tf

FROM alpine:3.20@sha256:8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b

# Install dependencies
RUN apk add --no-cache \
    ca-certificates \
    curl \
    git \
    jq \
    unzip \
    aws-cli

# Install 1Password CLI
RUN curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
    gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg && \
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | \
    tee /etc/apt/sources.list.d/1password.list && \
    apt-get update && apt-get install -y 1password-cli && \
    rm -rf /var/lib/apt/lists/*

# Copy Terraform from first stage
COPY --from=tf /usr/local/bin/terraform /usr/local/bin/terraform

# Create non-root user
RUN addgroup -S app && adduser -S app -G app

# Set working directory
WORKDIR /workspace

# Switch to non-root user
USER app

# Default entrypoint
ENTRYPOINT ["/bin/sh", "-lc"]
