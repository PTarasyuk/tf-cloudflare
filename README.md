# TF-Cloudflare

## Overview

This project showcases an example of a Terraform module developed for managing Cloudflare configurations using Cloudflare R2 Bucket as a backend for remote Terraform state storage. This approach allows for the centralization of resource management within a single ecosystem. As a result, it simplifies management and enhances security levels, as all accesses and changes can be meticulously controlled.

**Example of using Cloudflare R2 Bucket as a backend for remote Terraform state storage**:

```terraform
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket                      = "terraform"
    key                         = "Your_Project_Name/terraform.tfstate"
    endpoints                   = { s3 = "https://Your_Cloudflare_Account_ID.r2.cloudflarestorage.com" }
    access_key                  = "Your_Cloudflare_R2_Access_Key"
    secret_key                  = "Your_Cloudflare_R2_Secret_Key"    
    region                      = "auto"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
  }
}
```

### Examples of Cloudflare configurations

- Deploy an MkDocs site to Cloudflare Pages

## Prerequisites

### Cloudflare R2 Bucket for Terraform Backend

You will need to account ID and API token. [See more here](https://developers.cloudflare.com/r2/api/s3/tokens/).

   - You can find your Account ID in the Cloudflare dashboard on the [R2 Overview page](https://dash.cloudflare.com/?to=/:account/r2/overview) on the right side.
   - And you will need to generate an API Token by following the link to the [R2 API Tokens page](https://dash.cloudflare.com/?to=/:account/r2/api-tokens).

### Configure Cloudflare with IaC tool - Terraform

You will need to [Global API Key](https://developers.cloudflare.com/fundamentals/api/get-started/keys/). [See more here](https://developers.cloudflare.com/terraform/)

### GitHub Account Access

For deploying projects to Cloudflare Pages from a GitHub repository, Cloudflare Pages must be authorized to access your GitHub account. Comprehensive information on this process can be found in [Cloudflare’s documentation on Git integration](https://developers.cloudflare.com/pages/configuration/git-integration/#organizational-access).

## Usage

1. **Clone the Repository**: Begin by cloning this repository to your local machine.

   ```shell
   git clone https://github.com/PTarasyuk/tf-cloudflare
   ```

2. **Configuration Terraform Backend**:

   - Copy `config.s3.tfbackend.example` and rename it `config.s3.tfbackend`:

     ```shell
     cp config.s3.tfbackend.example config.s3.tfbackend
     ```

   - In `config.s3.tfbackend`, replace the values obtained in "[Cloudflare R2 Bucket for Terraform Backend](#cloudflare-r2-bucket-for-terraform-backend)" with the following values:
      - `Your_Project_Name`
      - `Your_Cloudflare_Account_ID`
      - `Your_Cloudflare_R2_Access_Key`
      - `Your_Cloudflare_R2_Secret_Key`

3. **Configuration Terraform Variables**:

   - Copy `terraform.tfvars.example` and rename it `terraform.tfvars`:

     ```shell
     cp terraform.tfvars.example terraform.tfvars
     ```

   - In `terraform.tfvars`, replace the values obtained in "[Configure Cloudflare with IaC tool - Terraform](#configure-cloudflare-with-iac-tool-terraform)" with the following values:
      - `Your@Email`
      - `Your_Cloudflare_Global_Api_Key`
      - `Your_Cloudflare_Account_ID`

      And also

      - `Your_Project_Name` - your Cloudflare Page will be available via a link <https://Your_Project_Name.pages.dev>
      - `Your_Source_Owner` - GitHub project owner username
      - `Your_Source_Repo` - GitHub project repository name

3. **Initialization**: Navigate to the project directory and run the following command to initialize Terraform, allowing it to download necessary providers and modules.

   ```shell
   make init
   ```

4. **Apply Configuration**: Execute the following command to apply your configuration. Terraform will display a plan and prompt for confirmation before making any changes.

   ```shell
   make apply
   ```

5. **Verification**: After successful deployment, verify the configuration on your Cloudflare dashboard.

## Terraform Configuration Overview
<!-- BEGIN_TF_DOCS -->
### Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 4.25.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.2 |

### Resources

| Name | Type |
|------|------|
| [cloudflare_pages_project.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/pages_project) | resource |
| [null_resource.deploy_trigger](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Cloudflare Account ID. | `string` | n/a | yes |
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | Cloudflare Global API Key. | `string` | n/a | yes |
| <a name="input_build_command"></a> [build\_command](#input\_build\_command) | Command used to build project. | `string` | `"mkdocs build"` | no |
| <a name="input_destination_dir"></a> [destination\_dir](#input\_destination\_dir) | Output directory of the build. | `string` | `"site"` | no |
| <a name="input_email"></a> [email](#input\_email) | A registered Cloudflare email address. | `string` | n/a | yes |
| <a name="input_production_branch"></a> [production\_branch](#input\_production\_branch) | Project production branch name. | `string` | `"main"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project. | `string` | n/a | yes |
| <a name="input_root_dir"></a> [root\_dir](#input\_root\_dir) | Your project's root directory, where Cloudflare runs the build command. | `string` | `""` | no |
| <a name="input_source_owner"></a> [source\_owner](#input\_source\_owner) | Project owner username. Modifying this attribute will force creation of a new resource. | `string` | n/a | yes |
| <a name="input_source_repo"></a> [source\_repo](#input\_source\_repo) | Project repository name. Modifying this attribute will force creation of a new resource. | `string` | n/a | yes |
| <a name="input_source_type"></a> [source\_type](#input\_source\_type) | Project host type. (github or gitlab) | `string` | `"github"` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudflare_page_domains"></a> [cloudflare\_page\_domains](#output\_cloudflare\_page\_domains) | A list of associated custom domains for the Cloudflare Page project |
<!-- END_TF_DOCS -->
## Contributing

We welcome contributions to our project! Please check out our [Contribution Guidelines](CONTRIBUTING.md) for more information on how to get involved.

## Coding Style

Before contributing, please read our [Coding Style Guidelines](CODING_STYLE.md) to ensure consistency throughout the codebase.

## Code Of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md).
By participating in this project you agree to abide by its terms.

## Recommendations for Improvement

- **Add more examples**:
    - **Secure a Website with Cloudflare Access**: Demonstrate how to use Terraform to configure Cloudflare Access policies to protect your website, including setting up access rules based on user identity or network location.
    - **Automate DNS Record Management**: Provide a step-by-step example on managing DNS records for a domain through Terraform, showcasing how to automate the creation and update of A, CNAME, and TXT records.
    - **Set Up Cloudflare Workers**: Illustrate the process of deploying and managing Cloudflare Workers using Terraform, including script deployment and route configuration for edge computing solutions.
    - **Implement Rate Limiting Rules**: Show how to use Terraform to implement Cloudflare Rate Limiting to protect against DDoS attacks and abusive bots, detailing the configuration of thresholds and actions.
    - **Configure Cloudflare Page Rules**: Offer an example of configuring Cloudflare Page Rules to customize Cloudflare features and optimize site performance, such as URL forwarding, cache control, and security settings.
    - **Enable Cloudflare Argo Tunnel**: Guide users through setting up a Cloudflare Argo Tunnel with Terraform, explaining how to securely connect web servers to Cloudflare's network without exposing them to the public internet.
    - **Manage Cloudflare Firewall Rules**: Provide examples on creating and managing Cloudflare Firewall Rules to control incoming traffic based on IP addresses, geolocation, or security threats.
    - **Optimize Website Performance with Cloudflare Settings**: Show how to configure Cloudflare performance settings through Terraform, such as automatic HTTPS rewrites, minification of resources, and mobile redirection.
- **Troubleshooting Guide**: A section dedicated to common issues and their solutions would greatly aid users in resolving problems without needing to seek external help.
- **FAQ Section**: Incorporate a Frequently Asked Questions (FAQ) section to address common queries, facilitating a smoother user experience.
- **Changelog**: Maintain a changelog to track and communicate changes, updates, and improvements to the project over time.

## License

This project is licensed under the [MIT License](LICENSE). See the LICENSE file for more details.
