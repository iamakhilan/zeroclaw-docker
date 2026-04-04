# Use lightweight Linux
FROM ubuntu:22.04

# Avoid interaction prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt install -y \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Zeroclaw (Rust binary)
RUN curl -fsSL https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN cargo install zeroclaw

# Create working directory
WORKDIR /root

# Expose port (Render needs this)
EXPOSE 10000

# Start Zeroclaw
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]