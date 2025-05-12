# Stage 1: Build the Rust binary
FROM rust:slim AS builder

# Set work directory inside the container
WORKDIR /learn-cicd

# Copy Cargo.toml and source files
COPY . .

# Build the project
RUN cargo build --release --bin learn-cicd

# Stage 2: Create a minimal runtime image
FROM debian:trixie-slim AS runtime

WORKDIR /learn-cicd

# Copy the compiled binary from builder stage
COPY --from=builder /learn-cicd/target/release/learn-cicd /usr/local/bin/

# Run the binary
ENTRYPOINT ["/usr/local/bin/learn-cicd"]
