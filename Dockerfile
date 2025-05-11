# Stage 1: Build the Rust binary
FROM rust:1.86.0 as builder

# Set the working directory inside the container
WORKDIR /app

# Pre-cache dependencies
COPY Cargo.toml Cargo.lock ./
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo fetch

# Copy source code and assets
COPY . .

# Build the release version
RUN cargo build --release

# Stage 2: Create a minimal final image
FROM debian:bullseye-slim

# Install required libraries (optional: for TLS support)
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# Copy the compiled binary from the builder
COPY --from=builder /app/target/release/learn-cicd /usr/local/bin/app

# Copy the assets directory (contains index.html)
COPY assets /assets

# Set the working directory (optional, just for clarity)
WORKDIR /assets

# Expose the port your app runs on
EXPOSE 8080

# Run the binary
CMD ["app"]
