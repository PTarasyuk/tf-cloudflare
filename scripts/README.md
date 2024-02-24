# Cloudflare R2 Bucket Management for Terraform Backend

## Requirements

### Cloudflare Authentication

To use this script, you need to have an Account ID and an API token.
You can find your Account ID in the Cloudflare dashboard on the [R2 Overview page](https://dash.cloudflare.com/?to=/:account/r2/overview) on the right side.
And you will need to generate an API Token by following the link to the [R2 API Tokens page](https://dash.cloudflare.com/?to=/:account/r2/api-tokens).
[See more here](https://developers.cloudflare.com/r2/api/s3/tokens/).

### `jq`

`jq` is a command-line JSON processor, allowing data parsing and manipulation.
Install via Homebrew using: `brew install jq`.
Ideal for scripting and API data handling.
