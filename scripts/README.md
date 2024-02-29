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

## Using `tf-backend-mgmt.sh`

Script to manage Cloudflare R2 buckets for Terraform Backend.

Usage: 

```shell
tf-backend-mgmt.sh -t YOUR_API_TOKEN -a YOUR_ACCOUNT_ID
```

- `-t, --token <YOUR_API_TOKEN>` - Your Cloudflare API Token
- `-a, --account <YOUR_ACCOUNT_ID>` - Your Cloudflare Account ID
- `-C <YOUR_BUCKET_NAME>` - Create Bucket with `<YOUR_BUCKET_NAME>` name
- `-c, --create` - Create Bucket with name defined in environment variables
- `-G <YOUR_BUCKET_NAME>` - View Bucket with `<YOUR_BUCKET_NAME>` name
- `-g, --get` - View Bucket with name defined in environment variables
- `-D <YOUR_BUCKET_NAME>` - Delete Bucket with `<YOUR_BUCKET_NAME>` name
- `-d, --delete` - Delete Bucket with name defined in environment variables
- `-l, --list` - List buckets
- `-e, --env` - Use environment variables
- `-h, --help` - Display this help
