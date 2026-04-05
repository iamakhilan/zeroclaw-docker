FROM ubuntu:22.04

# Avoid interaction prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt install -y \
    curl \
    ca-certificates \
    build-essential \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl -fsSL https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Zeroclaw
RUN cargo install zeroclaw

# Create working directory
WORKDIR /root

# Expose port
EXPOSE 10000

# Start Zeroclaw
COPY start.sh /start.sh
RUN chmod +x /start.sh

# REMOVED the problematic chown/chmod line
# The permissions are already fine from the previous steps

CMD ["/start.sh"]