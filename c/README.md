# C/C++ Agent

A Jenkins agent image for compiling, building, and debugging C and C++ projects.

| Capability | Tools |
| --- | --- |
| Compile C and C++ | GCC, G++, build-essential |
| Configure and build projects | Make, CMake, Ninja, pkg-config |
| Debug and check memory usage | GDB, Valgrind |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.