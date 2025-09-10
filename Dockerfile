# Multi-stage build for Terraform with 1Password CLI
FROM hashicorp/terraform:1.9.5 as tf

FROM alpine:3.20

# Install dependencies
RUN apk add --no-cache \
    ca-certificates \
    curl \
    git \
    jq \
    unzip \
    aws-cli \
    gnupg

# Install 1Password CLI (download binary directly for Alpine)
RUN curl -sS https://cache.agilebits.com/dist/1P/op2/pkg/v2.24.0/op_linux_amd64_v2.24.0.zip -o op.zip && \
    unzip op.zip && \
    mv op /usr/local/bin/ && \
    chmod +x /usr/local/bin/op && \
    rm op.zip

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
