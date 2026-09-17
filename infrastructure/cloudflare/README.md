# Cloudflare Pages

This configuration creates the direct-upload Cloudflare Pages project and attaches `templates.achim.io`.

Authenticate Terraform with `CLOUDFLARE_API_TOKEN`, then run `terraform init` and `terraform apply -var 'cloudflare_account_id=<account-id>'` from this directory.

Because `achim.io` uses Porkbun DNS, add a CNAME record for host `templates` pointing to `fluttertemplates.pages.dev` after applying Terraform.

The Codemagic `cloudflare_credentials` group must contain `CLOUDFLARE_ACCOUNT_ID` and secret `CLOUDFLARE_API_TOKEN` before the web workflow can publish the build.
