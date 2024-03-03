# Define variables for Terraform backend configuration, variable settings, and documentation configuration.
TF_BACKEND_CONF := config.s3.tfbackend
TF_VARS := terraform.tfvars
TF_DOC_CONF := doc-config.yml

# Export a variable to track the check status, initializing it as "Failed".
export CHECK_STATUS := "Failed"

help: # Target to display help message, listing all targets with their descriptions.
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@awk '/^[a-zA-Z\-\_0-9]+:/ {                              \
		nb = sub( /^## /, "", helpMsg );                      \
		if(nb == 0) {                                         \
			helpMsg = $$0;                                    \
			nb = sub( /^[^:]+:.* ## /, "", helpMsg );         \
		}                                                     \
		if (nb)                                               \
			printf "\033[36m%-20s\033[0m %s\n", $$1, helpMsg; \
	}                                                         \
	{ helpMsg = $$0 }'                                        \
	$(MAKEFILE_LIST)
	@echo ""
	@echo ""


fmt: ## Target to format Terraform source code.
	@terraform fmt


gendoc: ## Target to generate Terraform documentation in README.md.
	@if [ -f $(TF_DOC_CONF) ]; then \
		terraform-docs -c doc-config.yml .; \
	else \
		echo "File '$(TF_DOC_CONF)' not found."; \
	fi


check: ## Target to check the Terraform configuration by verifying backend and tfvars files.
	$(eval CHECK_STATUS:=$(shell \
		if [ -f $(TF_BACKEND_CONF) ]; then \
			if [ -f $(TF_VARS) ]; then \
				cf_email=$$(awk -F'"' '/email/{print $$2}' $(TF_VARS)); \
				cf_api_key=$$(awk -F'"' '/api_key/{print $$2}' $(TF_VARS)); \
				cf_account_id=$$(awk -F'"' '/account_id/{print $$2}' $(TF_VARS)); \
				http_code=$$(curl  -s -o /dev/null -w "%{http_code}" -X GET "https://api.cloudflare.com/client/v4/accounts/$$cf_account_id/r2/buckets" \
    	 			-H "X-Auth-Email: $$cf_email" \
    	 			-H "X-Auth-Key: $$cf_api_key" \
    	 			-H "Content-Type: application/json"); \
				if [ $$http_code -eq 200 ]; then \
					cf_bucket=$$(awk -F'"' '/bucket/{print $$2}' $(TF_BACKEND_CONF)); \
					http_code=$$(curl  -s -o /dev/null -w "%{http_code}" -X GET "https://api.cloudflare.com/client/v4/accounts/$$cf_account_id/r2/buckets/$$cf_bucket" \
    	 				-H "X-Auth-Email: $$cf_email" \
    	 				-H "X-Auth-Key: $$cf_api_key" \
    	 				-H "Content-Type: application/json"); \
					if [ $$http_code -eq 200 ]; then \
						echo "Success"; \
					else \
						http_code=$$(curl  -s -o /dev/null -w "%{http_code}" -X POST "https://api.cloudflare.com/client/v4/accounts/$$cf_account_id/r2/buckets/" \
    	 					-H "X-Auth-Email: $$cf_email" \
    	 					-H "X-Auth-Key: $$cf_api_key" \
    	 					-H "Content-Type: application/json" \
							-d '{"name": "'$$cf_bucket'"}'); \
						if [ $$http_code -eq 200 ]; then \
							echo "Success"; \
						else \
							echo "Failed"; \
						fi; \
					fi; \
				else \
					echo "Failed"; \
				fi; \
			else \
				echo "Failed"; \
			fi; \
		else \
			echo "Failed"; \
		fi) \
	)
	@echo "Check - $(CHECK_STATUS)"

init: fmt check ## Target to initialize Terraform if the check was successful.
	@if [ $(CHECK_STATUS) = "Success" ]; then \
		echo "Terraform init..."; \
		terraform init -backend-config=config.s3.tfbackend; \
	fi

validate: gendoc fmt ## Target to format code and then validate Terraform configuration.
	@terraform validate

apply: validate ## Target to validate configuration and then apply Terraform plan.
	@terraform apply

docs-srv: gendoc
	@mkdocs serve