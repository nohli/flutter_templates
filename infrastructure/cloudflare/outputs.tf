output "pages_subdomain" {
  description = "Cloudflare Pages hostname used as the Porkbun CNAME target."
  value       = "${cloudflare_pages_project.web.name}.pages.dev"
}

output "custom_domain" {
  description = "Public custom domain attached to the Pages project."
  value       = cloudflare_pages_domain.web.name
}
