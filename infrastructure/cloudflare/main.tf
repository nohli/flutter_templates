provider "cloudflare" {}

resource "cloudflare_pages_project" "web" {
  account_id        = var.cloudflare_account_id
  name              = "templates-achim-io"
  production_branch = "main"
}

resource "cloudflare_pages_domain" "web" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.web.name
  name         = "templates.achim.io"
}
