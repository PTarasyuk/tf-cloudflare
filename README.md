# TF-Cloudflare

Example of Terraform module for working with Cloudflare

## Prerequisites

### Create a Cloudflare R2 Bucket for a Terraform backend

Create the bucket using the `./scripts/tf-backend-mgmt.sh` script. See more in [`./scripts/README.md`](./scripts/README.md)

### Access to GitHub account

To deploy a project to Cloudflare Pages from a GitHub repository, you need to authorize Cloudflare Pages to access your GitHub account.
More information can be seen on [Cloudflare’s documentation](https://developers.cloudflare.com/pages/configuration/git-integration/#organizational-access).

