output "cloudflare_page_domains" {
  description = "A list of associated custom domains for the Cloudflare Page project"
  value       = cloudflare_pages_project.this.domains
}