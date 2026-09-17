# Cloudflare Pages

Optional web hosting: this configuration creates a direct-upload Pages project and attaches your custom hostname.
Running the Flutter app requires no Terraform or Cloudflare setup.

To provision your own hosting:

1. Supply a Cloudflare API token through `CLOUDFLARE_API_TOKEN` in your environment.
2. From this directory, initialize Terraform and apply with your account, project name and hostname:

   ```sh
   terraform init
   terraform apply \
     -var 'cloudflare_account_id=<your-account-id>' \
     -var 'pages_project_name=<your-project-name>' \
     -var 'custom_domain=<your-hostname>'
   ```

3. Configure your DNS CNAME to the `pages_subdomain` output, following
   [Cloudflare's custom-domain instructions](https://developers.cloudflare.com/pages/configuration/custom-domains/).
4. For optional Codemagic publishing, set `CLOUDFLARE_ACCOUNT_ID`, secret `CLOUDFLARE_API_TOKEN`
   and `CLOUDFLARE_PAGES_PROJECT` in its `cloudflare_credentials` group. Use the same project name.

No account, project or domain has a default. Keep tokens and Terraform state out of Git.
You can save the three non-secret inputs in an ignored `terraform.tfvars` in this directory;
Terraform loads it automatically, so normal `terraform plan` and `terraform apply` need no `-var` flags.
The API token stays in `CLOUDFLARE_API_TOKEN`, outside this file.
For an existing deployment, retain its state and supply the existing values before applying;
review the plan for unintended replacements. Provisioning manages hosting resources;
Codemagic publishes the built web content.
