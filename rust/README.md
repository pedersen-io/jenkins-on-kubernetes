# Rust Agent

A Jenkins agent image for building, testing, formatting, and linting Rust projects.

| Capability | Tools |
| --- | --- |
| Compile and manage Rust projects | Rust toolchain, `rustc`, Cargo, rustup |
| Format Rust code | rustfmt |
| Lint Rust code | Clippy |
| Build native dependencies | build-essential, pkg-config, OpenSSL development headers |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.