variable "email" {
  type        = string
  description = "A registered Cloudflare email address."
}

variable "api_key" {
  type        = string
  description = "Cloudflare Global API Key."
}

variable "account_id" {
  type        = string
  description = "Cloudflare Account ID."
}

# -----------------------------------------------
# Cloudflare Pages
# -----------------------------------------------

variable "project_name" {
  type        = string
  description = "Name of the project."
}

variable "production_branch" {
  type    = string
  description = "Project production branch name."
  default = "main"
}

# Configuration for the project build process.

variable "build_command" {
  # More see: https://developers.cloudflare.com/pages/configuration/build-configuration/
  type    = string
  description = "Command used to build project."
  default = "mkdocs build"
}

variable "destination_dir" {
  type    = string
  description = "Output directory of the build."
  default = "site"
}

variable "root_dir" {
  type    = string
  description = "Your project's root directory, where Cloudflare runs the build command."
  default = ""
}

# Configuration for the project source.

variable "source_type" {
  type    = string
  description = "Project host type. (github or gitlab)"
  default = "github"
}

variable "source_owner" {
  type        = string
  description = "Project owner username. Modifying this attribute will force creation of a new resource."
}

variable "source_repo" {
  type        = string
  description = "Project repository name. Modifying this attribute will force creation of a new resource."
}