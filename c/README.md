# C/C++ Agent

[C/C++](https://isocpp.org/)

A Jenkins agent image for compiling, building, and debugging C and C++ projects.

## Why this agent exists
This image gives Jenkins a native toolchain for C and C++ projects without requiring developers to hand-configure compilers, package managers, and debug utilities on every build node.

## What it builds
This agent is used to compile libraries, command-line tools, and native binaries; configure cross-platform builds; and validate applications with compiler, linker, and debugging tooling.

## Common use cases
- Native application builds with GCC and G++
- CMake, Make, and Ninja-based build pipelines
- Debugging with GDB and memory checks with Valgrind
- Packaging and verification for systems and embedded-style workloads

| Capability | Tools |
| --- | --- |
| Compile C and C++ | [GCC](https://gcc.gnu.org/), [G++](https://gcc.gnu.org/), [build-essential](https://wiki.debian.org/BuildEssential) |
| Configure and build projects | [Make](https://www.gnu.org/software/make/), [CMake](https://cmake.org/), [Ninja](https://ninja-build.org/), [pkg-config](https://www.freedesktop.org/wiki/Software/pkg-config/) |
| Debug and check memory usage | [GDB](https://www.gnu.org/software/gdb/), [Valgrind](https://valgrind.org/) |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.