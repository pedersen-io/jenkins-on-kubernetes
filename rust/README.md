# Rust Agent

[Rust](https://www.rust-lang.org/)

A Jenkins agent image for building, testing, formatting, and linting Rust projects.

## Why this agent exists
This image gives Jenkins the Rust toolchain and native build dependencies needed to compile safe, performant Rust code in repeatable CI jobs.

## What it builds
This agent is used for Rust library and binary builds, dependency management, linting, formatting, and validation of native integration projects.

## Common use cases
- `cargo build` and `cargo test` pipelines
- CLI and service compilation in Rust
- Formatting and lint enforcement with `rustfmt` and Clippy
- Native dependency work for OpenSSL and system libraries

| Capability | Tools |
| --- | --- |
| Compile and manage Rust projects | [Rust toolchain](https://www.rust-lang.org/), [`rustc`](https://doc.rust-lang.org/stable/rustc/), [Cargo](https://doc.rust-lang.org/cargo/), [rustup](https://rustup.rs/) |
| Format Rust code | [rustfmt](https://github.com/rust-lang/rustfmt) |
| Lint Rust code | [Clippy](https://doc.rust-lang.org/clippy/) |
| Build native dependencies | [build-essential](https://wiki.debian.org/BuildEssential), [pkg-config](https://www.freedesktop.org/wiki/Software/pkg-config/), [OpenSSL](https://www.openssl.org/) development headers |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.