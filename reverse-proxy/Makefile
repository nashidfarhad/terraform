# Check for specific environment variables
env-%:
	@ if [ "${${*}}" = "" ]; then \
			echo "Environment variable $* not set"; \
			exit 1; \
	fi


shell: env-AWS_ACCOUNT_ID
	docker-compose run --rm \
		-e TF_VAR_aws_account_id=$(AWS_ACCOUNT_ID) \
		--entrypoint "/bin/bash" \
		terraform
.PHONY: shell

#Deployment commands for staging

init_stage: env-WORKSPACE_STAGE
	docker-compose run --rm terraform init
	docker-compose run --rm terraform workspace new $(WORKSPACE_STAGE) 2>/dev/null; true # ignore if workspace already exists
	docker-compose run --rm terraform workspace "select" $(WORKSPACE_STAGE)
.PHONY: init_stage

show_stage: env-WORKSPACE_STAGE
	docker-compose run --rm terraform show
.PHONY: show_stage

apply_stage: env-AWS_ACCOUNT_ID env-WORKSPACE_STAGE
	@echo "+++ :terraform: Terraform Apply"
	docker-compose run --rm \
		-e TF_VAR_aws_account_id=$(AWS_ACCOUNT_ID) \
		terraform apply .terraform-plan-$(WORKSPACE_STAGE)
.PHONY: apply_stage

plan_stage: env-AWS_ACCOUNT_ID env-WORKSPACE_STAGE
	@echo "+++ :terraform: Terraform Plan"
	docker-compose run --rm \
		-e TF_VAR_aws_account_id=$(AWS_ACCOUNT_ID) \
		terraform plan -out=.terraform-plan-$(WORKSPACE_STAGE)
.PHONY: plan_stage
