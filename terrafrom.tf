terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "terraform"
    key    = "kindergrow/terraform.tfstate"
    endpoints = { s3 = "https://xxxxx.r2.cloudflarestorage.com" }
    region = "auto"

    access_key = "xxxx"
    secret_key = "xxxxx"
    skip_credentials_validation = true
    skip_region_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum = true
  }
}