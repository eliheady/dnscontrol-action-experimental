## DNSControl composite action

This is a composite GitHub action for running configurable DNSControl commands.

[DNSControl](https://dnscontrol.org) is an [opinionated](https://docs.dnscontrol.org/developer-info/opinions) platform for seamlessly managing your DNS configuration across any number of DNS hosts, both in the cloud or in your own infrastructure.

### Action Features

* Write DNSControl output to PRs, job summary, and/or a file of your choosing
* Run (or don't) a "preflight" `dnscontrol check` before your command; check failure will stop the job and write to the job summary
* Specify alternate locations for `dnsconfig.js` and `creds.json`
* Choose which version of DNSControl to run (the default is the latest release)

**Credentials**

You can pre-populate your `creds.json` file and pass in its path as an input, or you can set your API secrets in environment variables and rely on DNSControl's built-in variable interpolation to use variable values to authenticate to your providers.

**Inputs**

* **cmdargs**: The command and flags you want to run (required)
* **dnsconfig_file**: The alternate location of `dnsconfig.js` (optional)
* **creds_file**: The alternate location of `creds.json` (optional)
* **output_file**: The file into which the command output should be written (optional)
* **post_pr_comment**: Post the command output to a PR comment (true/false, default is false)
* **post_summary**: Post the command output to the running job summary (true/false, default is false)

**Outputs**

* **output**: The output from the dnscontrol command you specified
* **output_file**: The workspace file (if you specified) into which output from the dnscontrol command was written

**Usage Example**

Run `dnscontrol preview` from a PR:

```yaml
# yaml-language-server: $schema=https://json.schemastore.org/github-workflow.json

name: DNSControl

on:
  pull_request:
    paths:
      - '*dnsconfig.js'
      - '*creds.json'

permissions: 
  contents: read
  pull-requests: write 

jobs:
  preview:
    runs-on: ubuntu-latest
    if: ${{ !cancelled() }}
    steps:
      -
        name: Checkout repo
        uses: actions/checkout@v4
      -
        # add all secrets needed for creds.json variable interpolation
        name: Prepare secrets
        id: secrets
        run: |
          cat >>${GITHUB_ENV}<<EOF
          DNSCONTROL_ROUTE53_KEY_ID=${{ secrets.DNSCONTROL_ROUTE53_KEY_ID }}
          DNSCONTROL_ROUTE53_KEY=${{ secrets.DNSCONTROL_ROUTE53_KEY }}
          EOF
      -
        # call the action with options to run `dnscontrol check` before `dnscontrol preview`,
        # post to the PR, and post to the job summary
        name: call dnscontrol action
        uses: eliheady/dnscontrol-action-experiment@02d8504cd0ff93bd974872c81f2553c4e578dcb6 # V0.0.2
        with:
          cmdargs: preview
          post_pr_comment: true
          post_summary: true
          check: true
```