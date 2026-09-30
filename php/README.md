# PHP Agent

A Jenkins agent image for building and testing PHP applications, including Composer-managed projects.

| Capability | Tools |
| --- | --- |
| Run PHP applications and scripts | PHP CLI |
| Manage dependencies | Composer |
| Common application integrations | PHP extensions: curl, mbstring, XML, ZIP, SQLite |
| Source control and archive handling | Git, unzip |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.