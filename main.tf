provider "cloudflare" {
  email   = var.email
  api_key = var.api_key
}

# Provides a resource which manages Cloudflare Pages projects.
resource "cloudflare_pages_project" "this" {
  account_id        = var.account_id
  name              = var.project_name
  production_branch = var.production_branch

  # Configuration for the project build process.
  # Read more in the [documentation](https://developers.cloudflare.com/pages/platform/build-configuration).
  build_config {
    build_command   = var.build_command
    destination_dir = var.destination_dir
    root_dir        = var.root_dir
  }

  # Configuration for the project source.
  # Read more in the [documentation](https://developers.cloudflare.com/pages/platform/branch-build-controls/).
  source {
    type = var.source_type
    config {
      owner             = var.source_owner
      repo_name         = var.source_repo
      production_branch = var.production_branch
    }
  }
}

resource "null_resource" "deploy_trigger" {
  depends_on = [cloudflare_pages_project.this]

  provisioner "local-exec" {
    command = "curl -X POST 'https://api.cloudflare.com/client/v4/accounts/${var.account_id}/pages/projects/${var.project_name}/deployments' -H 'X-Auth-Email: ${var.email}' -H 'X-Auth-Key: ${var.api_key}' -H 'Content-Type: application/json'"
  }
}