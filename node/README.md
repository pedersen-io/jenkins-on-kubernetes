# Node.js Agent

A Jenkins agent image for Node.js builds, frontend workflows, and headless Chrome tasks.

| Capability | Tools |
| --- | --- |
| Run Node.js and npm workflows | Node.js, npm, `npx` |
| Manage packages | Yarn |
| Build Angular and Vue applications | Angular CLI, Vue CLI |
| Run headless Chrome tasks | Chrome Headless Shell |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.