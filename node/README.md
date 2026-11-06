# Node.js Agent

[Node.js](https://nodejs.org/)

A Jenkins agent image for Node.js builds, frontend workflows, and headless Chrome tasks.

## Why this agent exists
This image gives Jenkins a JavaScript runtime and the common package and browser tooling needed for modern frontend and backend Node.js pipelines.

## What it builds
This agent is used for Node.js application builds, package management, frontend compilation, and browser automation in CI pipelines.

## Common use cases
- npm, pnpm, and Yarn builds
- Angular, React, and Vue frontend compilation
- Server-side Node.js services and test suites
- Browser automation and headless validation with Chrome

| Capability | Tools |
| --- | --- |
| Run Node.js and npm workflows | [Node.js](https://nodejs.org/), [npm](https://www.npmjs.com/), [`npx`](https://docs.npmjs.com/cli/v10/commands/npx) |
| Manage packages | [Yarn](https://yarnpkg.com/) |
| Build Angular and Vue applications | [Angular CLI](https://angular.io/cli), [Vue CLI](https://cli.vuejs.org/) |
| Run headless Chrome tasks | [Chrome Headless Shell](https://developer.chrome.com/docs/chromium/headless) |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.