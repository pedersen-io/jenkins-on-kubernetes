# Playwright Agent

[Playwright](https://playwright.dev/)

A Jenkins agent image for automated cross-browser testing with Playwright.

## Why this agent exists
This image gives Jenkins the Node.js and browser-testing stack needed to run reliable end-to-end UI tests at scale without bespoke browser setup on every worker.

## What it builds
This agent is used to execute Playwright test suites across major browser engines and validate application behavior from the user’s perspective.

## Common use cases
- Browser automation for web UI pipelines
- Cross-browser regression testing
- End-to-end validation of deployments and releases
- Testing of frontend flows that require real browser behavior

| Capability | Tools |
| --- | --- |
| Run Playwright test workflows | [Node.js](https://nodejs.org/), [npm](https://www.npmjs.com/), [Playwright](https://playwright.dev/) |
| Test across supported browser engines | [Chromium](https://www.chromium.org/), [Firefox](https://www.mozilla.org/firefox/), [WebKit](https://webkit.org/) and their installed dependencies |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.