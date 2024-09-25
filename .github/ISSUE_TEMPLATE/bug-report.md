---
name: Bug Report
about: Something isn't working as expected
labels:
    - bug
    - triage
---

## Bug Report

### Description
<!-- A description of what you were trying to do (error logs should go in the section at the end)-->



### Expected behavior
<!-- A short description of what you expected to happen. -->



### Actual behavior
<!-- A short description of what actually happened. (error log goes in its own section!) -->



### Environment

-  **Action version:** <!-- x.x.x -->

### Configuration

<!--
Please provide your job/workflow definition between the code fences (```).
-->

<details>
<summary>GitHub Actions Job Definition</summary>

```yaml

```

</details>

<details>
<summary>Semantic Release Configuration</summary>

```toml

```

</details>

### Execution Log

<!--
Please include the log output from the job in the code fence (```)
with the -vv flag as a root_options argument applied to the GitHub Action.
-->

<details>
<summary><code>semantic-release -vv publish</code></summary>

```log

```

</details>

### Additional context

<!--
Feel free to add any other information that could be useful,
such as a link to your project (if public), links to a failing GitHub Action,
or an example commit.
-->
