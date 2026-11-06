# PHP Agent

[PHP](https://www.php.net/)

A Jenkins agent image for building and testing PHP applications, including Composer-managed projects.

## Why this agent exists
This image packages the PHP runtime and dependency tooling that Jenkins jobs need to compile, test, and deploy PHP applications consistently across teams.

## What it builds
This agent is used for PHP application runs, Composer installs, unit tests, and packaging of web or API projects built with PHP frameworks and extensions.

## Common use cases
- PHP CLI and web application builds
- Composer-based dependency resolution
- PHPUnit and application test pipelines
- API and CMS deployments that rely on common PHP extensions

| Capability | Tools |
| --- | --- |
| Run PHP applications and scripts | [PHP CLI](https://www.php.net/manual/en/features.commandline.php) |
| Manage dependencies | [Composer](https://getcomposer.org/) |
| Common application integrations | PHP extensions: [curl](https://curl.se/), [mbstring](https://www.php.net/mbstring), [XML](https://www.php.net/xml), [ZIP](https://php.net/zip), [SQLite](https://www.sqlite.org/) |
| Source control and archive handling | [Git](https://git-scm.com/), [unzip](https://infozip.sourceforge.net/UnZip.html) |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.