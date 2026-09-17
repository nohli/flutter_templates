variable "cloudflare_account_id" {
  description = "Cloudflare account that owns the Pages project."
  type        = string
}

variable "pages_project_name" {
  description = "Name of the direct-upload Pages project."
  type        = string
}

variable "custom_domain" {
  description = "Hostname to attach to the Pages project."
  type        = string
}
