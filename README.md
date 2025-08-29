## DNSControl composite action

**Usage**

Example of running `dnscontrol preview` from a PR:

```yaml
# yaml-language-server: $schema=https://json.schemastore.org/github-workflow.json

name: DNSControl

on:
  workflow_dispatch:
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
        name: call dnscontrol action
        uses: eliheady/dnscontrol-action-experiment@09ee102d35cec26697214daa05e7d363e7c92770 # v0.0.1
        with:
          cmdargs: preview
          post_pr_comment: true
          post_summary: true
          check: true
```